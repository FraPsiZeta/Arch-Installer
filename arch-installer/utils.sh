#!/bin/bash

INTERACTIVE="yup"

ROOT_DATA_PATH="$(realpath $(dirname $BASH_SOURCE))/data"

_assert_root() {
    if [ "$EUID" -ne 0 ]; then
        printf "You need root privileges to execute this script.\n"
        exit 6
    fi
}

#: $1 Username
#: $2.. Command to execute
with_su() {
    check_user_arg $1 || exit 5
    local user="$1"
    shift
    sudo -u "$user" "$@"
}


_confirm() {
    while true; do
        read -r -p "${1:-Are you sure? [y/N]} " response
        case $response in
            [yY][eE][sS]|[yY])
                return true
                ;;
            [Nn][oO]|[Nn])
                return false
                ;;
            *)
                printf "Please answer yes or no.\n"
                ;;
        esac
    done

    return false
}

# $1: EFI partition
# $1: Boot options
systemdboot_setup(){
    [ -z "$1" ] || [ -z "$2" ] && printf "ERROR: Boot options and EFI partition required!\n" && exit 7

    local efi_path="/boot/efi"
    mkdir -p "$efi_path"
    umount "$efi_path" 2>/dev/null
    mount "$1" "$efi_path" || printf "ERROR: Unable to mount EFI partition $1\n" && exit 8
    local entry="arch"

    bootctl --path="$efi_path" install
    echo "default $entry" > "$efi_path/loader/loader.conf"
    cat > "$efi_path/loader/entries/$entry.conf" <<EOF
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options $2
EOF
}

# $1: EFI partition
simple_systemdboot_setup() {
    local uuid=$(find_root_uuid)
    [ -z "$uuid" ] && printf "ERROR: Unable to find UUID of root partition.\n" && exit 7

    systemdboot_setup "$1" "root=UUID=$uuid rw quiet splash"

}

# $1: EFI partition
# $2: LVM root volume path (like: /dev/volume/root)
encrypted_systemdboot_setup() {
    local uuid=$(find_root_uuid)
    [ -z "$uuid" ] && printf "ERROR: Unable to find UUID of root partition.\n" && exit 7

    systemdboot_setup "$1" "cryptdevice=UUID=$uuid:cryptlvm root=$2 quiet rw"

}

# $1: Source directory
# $2: Destination directory
confirm_copy() {
    printf "Following files will be copied to $2:\n"
    find "$1" -exec printf "'{}'\n" \;
    _confirm
}

check_user_arg() {
    [ -z "$1" ] && printf "Missing user argument.\n" && return 5

    local found=$(cut -d: -f1 /etc/passwd | while read -r user
    do
        if [ "$1" = "$user" ]; then
            printf "gotit"
            break
        fi
    done)

    if [ -z $found ]; then
        printf "User \'$1\' not found.\n"
        return 4
    fi

}

yay_install() {
    if [ $INTERACTIVE ]; then
        yay -Sy --answerclean All --answerdiff None "$@"
    else
        yay -Sy --noconfirm --answerclean All --answerdiff None "$@"
    fi
}

yay_uninstall() {
    if [ $INTERACTIVE ]; then
        yay -Rsc --answerclean All --answerdiff None "$@"
    else
        yay -Rsc --noconfirm --answerclean All --answerdiff None "$@"
    fi
}

pacman_install() {
    if [ $INTERACTIVE ]; then
        pacman -Sy --needed "$@"
    else
        pacman --noconfirm -Sy --needed "$@"
    fi
}

#: $1 User for whom call systemctl
systemctl_user() {
    with_su $1 systemctl --user $2 $3
}

#: $1 Extension path
get_ff_extension_id() {
    local installation_folder="/tmp/.tmp_extension"

    rm -rf "$installation_folder"
    mkdir "$installation_folder" && unzip -d "$installation_folder" "$1" 1>/dev/null
    local ID=$(openssl asn1parse -inform DER -in "$installation_folder/META-INF/mozilla.rsa" | sed -n 's/.*:\({[a-zA-Z0-9\-]*}\).*/\1/p')
    rm -rf "$installation_folder"
    printf "$ID"
}

find_root_uuid() {
    local dev=$(sed -n 's#^\([^[[:space:]]\+\)[[:space:]]\+/ .*#\1#p' /etc/mtab)
    blkid "$dev" | sed -n 's/.* UUID="\([^"]*\)".*/\1/p'
}

# Installs the entire content of $1 inside $2.
# Empty directory will not get copied over.
# $1: Source directory
# $2: Target directory
install_dir() {
    cd "$1"
    printf "Installing content of $1 in $2\n"
    mkdir -p "$2"
    find . -type f -exec cp -rp --parents '{}' "$2" \;
    cd -
}

# Links the entire content of $1 inside $2.
# $1: Source directory
# $2: Target directory
link_dir() {
    printf "Linking content of $1 in $2\n"
    cp -as $(realpath "$1"/.[^.]*) $2
    cp -as $(realpath "$1"/*) $2
}

# Installs the entire content of $1 inside $2.
# Empty directory will not get copied over.
# $1: Source directory
# $2: Target directory
sudo_install_dir() {
    cd "$1"
    printf "Installing content of $1 in $2\n"
    sudo mkdir -p "$2"
    sudo find . -type f -exec cp -rp --parents '{}' "$2" \;
    cd -
}


# $1: Source directory from which files got installed
# $2: Target directory where where files will get removed.
uninstall_dir() {
    cd "$1"
    printf "Removing content of $1 from $2\n"
    # Removing installed files
    find . -type f -exec rm "$2/"'{}' \;
    # Removing empty directories left behind
    find . ! -path . -type d -exec bash -c 'rm -d '"$2"'/{}' \; 2>/dev/null
    cd -
}


# $1: Source directory from which files got installed
# $2: Target directory where where files will get removed.
sudo_uninstall_dir() {
    cd "$1"
    printf "Removing content of $1 from $2\n"
    # Removing installed files
    sudo find . -type f -exec rm "$2/"'{}' \;
    # Removing empty directories left behind
    sudo find . ! -path . -type d -exec bash -c 'rm -d '"$2"'/{}' \; 2>/dev/null
    cd -
}
