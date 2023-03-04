#!/bin/bash

ROOT_PATH="$(realpath $(dirname $BASH_SOURCE))"
source "$ROOT_PATH/utils.sh"

BASE_DATA_PATH="$ROOT_DATA_PATH/base_data"
BASE_HOME_PATH="$BASE_DATA_PATH/home"
BASE_COMMON_PATH="$BASE_DATA_PATH/common"

BASE_PACKAGES=(
    "base" "base-devel" "openssh" "linux-headers"
    "lm_sensors" "man-db" "networkmanager" "networkmanager-openvpn"
    "bluez" "git" "cmake" "make" "automake" "autoconf" "intel-ucode"
    "sudo" "vim" "wget" "curl" "zip" "unzip"
)

APPLICATION_PACKAGES=(
    "firefox" "thunderbird" "spectacle" "zathura-pdf-mupdf"
    "gimp" "emacs"  "pass" "firefox-extension-passff"
    "nodejs" "firefox-tridactyl"
)

install_base() {
    pacman_install "${BASE_PACKAGES[@]}"
}

install_applications() {
    # Needed to avoid gpg broken keys after first install
    pacman_install "archlinux-keyring"
    pacman_install "${APPLICATION_PACKAGES[@]}"
    install_networkmanager
    install_tlp
}


#: $1 User to whom install emacs
install_user_applications() {
    check_user_arg $1 || exit 5

    install_yay "$1"
    install_spacemacs "$1"

}


#: $1 User to whom install emacs
install_emacs() {
    check_user_arg $1 || exit 5

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


#: $1 User to whom install spacemacs
install_spacemacs() {
    install_emacs $1
    pacman_install git
    git clone -b develop https://github.com/syl20bnr/spacemacs /home/"$1"/.emacs.d
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


#: $1 User to whom install yay
install_yay() {
    check_user_arg $1 || exit 5
    local yay_install_folder="/tmp/yay"
    pacman_install git base-devel
    with_su $1 git clone https://aur.archlinux.org/yay.git "$yay_install_folder"
    cd "$yay_install_folder"
    with_su $1 makepkg -si
}


install_networkmanager() {
    pacman_install networkmanager
    systemctl start NetworkManager
    systemctl enable NetworkManager
}

install_home_dotfiles() {
    link_home_files "$BASE_HOME_PATH"
}

install_common_files() {
    install_root_files "$BASE_COMMON_PATH"
}
