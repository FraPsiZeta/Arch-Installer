#!/bin/bash

INTERACTIVE="yup"

_assert_root() {
    if [ "$EUID" -ne 0 ]
    then
        printf "You need root privileges to execute this script.\n"
        exit 6
    fi
}

#: $1 Username
#: $2.. Command to execute
su() {
    check_user_arg $1 || exit 5
    local user="$1"
    shift
    sudo -u "$user" "$@"
}

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
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
        if [ "$1" = "$user" ]
        then
            printf "gotit"
            break
        fi
    done)

    if [ -z $found ]
    then
        printf "User \'$1\' not found.\n"
        return 4
    fi

}

yay_install() {
    if [ $INTERACTIVE ]
    then
        yay -Sy --answerclean All --answerdiff None "$@"
    else
        yay -Sy --noconfirm --answerclean All --answerdiff None "$@"
    fi
}

yay_uninstall() {
    if [ $INTERACTIVE ]
    then
        yay -Rsc --answerclean All --answerdiff None "$@"
    else
        yay -Rsc --noconfirm --answerclean All --answerdiff None "$@"
    fi
}

pacman_install() {
    if [ $INTERACTIVE ]
    then
        pacman -Sy --needed "$@"
    else
        pacman --noconfirm -Sy --needed "$@"
    fi
}

#: $1 User for whom call systemctl
systemctl_user() {
    su $1 systemctl --user $2 $3
}

#: $1 Extension path
get_ff_extension_id() {
    local installation_folder="$TMP_INSTALL_FOLDER/.tmp_extension"

    rm -rf "$installation_folder"
    mkdir "$installation_folder" && unzip -d "$installation_folder" "$1" 1>/dev/null
    local ID=$(openssl asn1parse -inform DER -in "$installation_folder/META-INF/mozilla.rsa" | sed -n 's/.*:\({[a-zA-Z0-9\-]*}\).*/\1/p')
    rm -rf "$installation_folder"
    printf "$ID"
}

find_root_uuid() {
    local dev=$(sed -n 's#^\([^[[:space:]]\+\)[[:space:]]\+/ .*#\1#p' /etc/mtab)

    for uuid in /dev/disk/by-uuid/*
    do
        if [ "$(readlink -f $uuid)" = "$dev" ]
        then
            basename $uuid
            break
        fi
    done

}

# Installs the entire content of $1 inside $2.
# Empty directory will not get copied over.
# $1: Source directory
# $2: Target directory
install_dir() {
    cd "$1"
    printf "Installing content of $1 in $2\n"
    find . -type f -exec cp -rp --parents '{}' "$2" \;
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
