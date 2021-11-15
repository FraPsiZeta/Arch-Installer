#!/bin/bash


INTERACTIVE="yup"
TMP_INSTALL_FOLDER="/tmp"


BASE_PACKAGES=(
    "base" "base-devel" "openssh" "lm_sensors" "man-db"
    "networkmanager" "networkmanager-openvpn" "bluez"
    "git" "cmake" "make" "automake" "autoconf"
    "sudo" "xbindkeys" "vim"
    "wget" "curl" "zip" "unzip" "ark"
 )

APPLICATION_PACKAGES=(
    "firefox" "thunderbird" "dolphin"
    "spectacle"  "mupdf"  "terminator"
    "gimp" "emacs"  "pass" "firefox-extension-passff"
    "nodejs"
)


KDE_PACKAGES=(
    "plasma-meta" "sddm" "xorg-server"
)


_assert_root() {
    if [ "$EUID" -ne 0 ]
    then
        printf "You need root privileges to execute this script.\n"
        exit 6
    fi
}

#: $1 Username
#: $2.. Command to execute
_su() {
    _check_user_arg $1 || exit 5
    local user="$1"
    shift
    sudo -u "$user" "$@"
}

_check_user_arg() {
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

_yay_install() {
    if [ $INTERACTIVE ]
    then
        yay -Sy --answerclean All --answerdiff None "$@"
    else
        yay -Sy --noconfirm --answerclean All --answerdiff None "$@"
    fi
}

_pacman_install() {
    if [ $INTERACTIVE ]
    then
        pacman -Sy --needed "$@"
    else
        pacman --noconfirm -Sy --needed "$@"
    fi
}

_systemctl() {
    systemctl $1 $2
}

set_timezone() {
    local region=${1:-Europe}
    local city=${2:-Rome}
    ln -sf /usr/share/zoneinfo/"$region"/"$city" /etc/localtime
    hwclock --systohc
}


generate_locale() {
    local locale=${1:-"en_US.UTF-8 UTF-8"}
    local lang=$(echo "$locale" | cut -d' ' -f1)

    sed -i "s/#$locale/$locale/g" /etc/locale.gen
    locale-gen

    echo "LANG=$lang" > /etc/locale.conf
}


install_networkmanager() {
    _pacman_install networkmanager
    _systemctl start NetworkManager
    _systemctl enable NetworkManager
}


install_yay() {
    _pacman_install git base-devel
    git clone https://aur.archlinux.org/yay.git "$TMP_INSTALL_FOLDER/yay"
    cd "$YAY_INSTALL_FOLDER/yay"
    makepkg -si
}

install_base() {
    _pacman_install "${BASE_PACKAGES[@]}"
}

install_applications() {
    _pacman_install "${APPLICATION_PACKAGES[@]}"
}

install_desktop() {
    _pacman_install "${KDE_PACKAGES[@]}"
    _systemctl enable sddm
    install_nordic_theme
}

#: $1 User to whom the themes will be installeed for.
install_nordic_theme() {
    if [ "$EUID" -eq 0 ]
    then
        printf "Makepkg installation should not be run as root.\n"
        printf "Skipping theme installation.\n"
        return 1
    fi

    _yay_install zafiro-icon-theme-git nordic-kde-git sddm-nordic-theme-git
    plasma-apply-lookandfeel -a Nordic
    /usr/lib/plasma-changeicons Zafiro
}

#: $1 Extension path
_get_ff_extension_id() {
    local installation_folder="$TMP_INSTALL_FOLDER/.tmp_extension"

    rm -rf "$installation_folder"
    mkdir "$installation_folder" && unzip -d "$installation_folder" "$1" 1>/dev/null
    local ID=$(openssl asn1parse -inform DER -in "$installation_folder/META-INF/mozilla.rsa" | sed -n 's/.*:\({[a-zA-Z0-9\-]*}\).*/\1/p')
    rm -rf "$installation_folder"
    printf "$ID"
    }

#: $1 User to whom install vimium
install_vimium() {
    _check_user_arg "$1" || return 2

    local user="$1"
    local vimium_url="https://addons.mozilla.org/firefox/downloads/file/3807948/vimium_ff-1.67-fx.xpi"

    xpi_path="$TMP_INSTALL_FOLDER/vimium.xpi"
    wget -O "$xpi_path" "$vimium_url"

    local _id=$(_get_ff_extension_id "$xpi_path")

    if [ -z "$_id" ]
    then
        printf "Unable to find extension ID for vimium. Installation failed.\n" >&2
        rm -f "$xpi_path"
        sleep 3
        return 1
    fi

    for dir in /home/"$user"/.mozilla/firefox/*.default-release/extensions
    do
        install -Dm644 "$xpi_path" "$dir/$_id.xpi"
    done

    rm -f "$xpi_path"
}

install_tlp() {
    _pacman_install tlp ethtool smartmontools x86_energy_perf_policy
    if [ $? -eq 0 ]
    then
        systemctl start tlp
        systemctl enable tlp
        systemctl mask systemd-rfkill.socket
        systemctl mask systemd-rfkill.service
    fi
}

_find_root_uuid() {
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

#: MacbookPro-specific installations:
#:---------------------------------:#
mbp_systemdboot_setup(){
    local boot_path="/boot"
    local entry="arch"
    local uuid=$(_find_root_uuid)

    bootctl --path="$boot_path" install
    echo "default $entry" > "$boot_path/loader/loader.conf"
    cat > '"$boot_path/loader/entries/$entry.conf"' <<EOF
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=UUID='"$uuid"' rw quiet splash acpi_osi=Darwin acpi_mask_gpe=0x06
EOF
}

mbp_setup_wifi() {
    modprobe -r b43 ssb wl bcma
    _pacman_install broadcom-wl
    modprobe wl
}


mbp_disable_thunderbolt() {
    local tb_sysfs="/sys/bus/pci/devices/0000:07:00.0"

    if grep "thunderbolt" "$tb_sysfs/uevent"
    then
        echo "$tb_sysfs/power/control - - - - auto" > /etc/tmpfiles.d/disable-thunderbolt.conf
    else
        echo "WARNING: Unable to disable thunderbolt controller."
        echo "Apparently it is not in the usual PCI path $tb_sysfs"
    fi
}
