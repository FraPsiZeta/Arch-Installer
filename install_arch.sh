#!/bin/bash

ROOT_PATH="$(realpath $(dirname $BASH_SOURCE))"
source "$ROOT_PATH/utils.sh"

TMP_INSTALL_FOLDER="/tmp"

BASE_PACKAGES=(
    "base" "base-devel" "openssh" "lm_sensors" "man-db"
    "networkmanager" "networkmanager-openvpn" "bluez"
    "git" "cmake" "make" "automake" "autoconf"
    "sudo" "vim" "wget" "curl" "zip" "unzip"
)

APPLICATION_PACKAGES=(
    "firefox" "thunderbird" "spectacle"  "mupdf"
    "gimp" "emacs"  "pass" "firefox-extension-passff"
    "nodejs" "firefox-tridactyl"
)

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
    pacman_install networkmanager
    systemctl start NetworkManager
    systemctl enable NetworkManager
}


install_yay() {
    pacman_install git base-devel
    git clone https://aur.archlinux.org/yay.git "$TMP_INSTALL_FOLDER/yay"
    cd "$TMP_INSTALL_FOLDER/yay"
    makepkg -si
}

install_base() {
    pacman_install "${BASE_PACKAGES[@]}"
}

install_applications() {
    pacman_install "${APPLICATION_PACKAGES[@]}"
}


install_tlp() {
    pacman_install tlp ethtool smartmontools x86_energy_perf_policy
    if [ $? -eq 0 ]
    then
        systemctl start tlp
        systemctl enable tlp
        systemctl mask systemd-rfkill.socket
        systemctl mask systemd-rfkill.service
    fi
}

#: $1 User to whom install emacs
install_emacs() {
    local user=$1
    pacman_install emacs
    systemctl_user $user enable emacs
    systemctl_user $user start emacs
    cat > /home/"$user"/.local/share/applications/emacs.desktop <<EOF
[Desktop Entry]
Name=Emacs (Client)
GenericName=Text Editor
Comment=Edit text
MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
Exec=emacsclient -c -a "emacs" %F
Icon=emacs
Type=Application
Terminal=false
Categories=Development;TextEditor;Utility;
StartupWMClass=Emacs
EOF
}
