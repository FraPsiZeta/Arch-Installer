#!/bin/bash


INTERACTIVE="yup"

TMP_INSTALL_FOLDER="/tmp"

VIMIUM_URL="https://addons.mozilla.org/firefox/downloads/file/3807948/vimium_ff-1.67-fx.xpi"

BASE_PACKAGES=(
    "base" "base-devel" "firefox" "thunderbird" "dolphin" "bluez" 
    "networkmanager" "networkmanager-openvpn" "lm_sensors" "spectacle" 
    "openssh" "git" "curl" "nodejs" "cmake" "make" "man-db" 
    "mupdf" "xbindkeys" "gimp" "zip" "ark" "automake" "autoconf"
    "emacs" "sudo" "vim" "wget" "terminator"
 )

KDE_PACKAGES=(
    "plasma-meta" "sddm" "xorg-server"
)


if [ "$EUID" -ne 0 ]
then
    IS_ROOT=""
else
    IS_ROOT="yup"
fi


_run_as_root() {
    if [ $IS_ROOT ]
    then
        "$@"
    else
        sudo "$@"
    fi
}

_yay_install() {
    if [ $INTERACTIVE ]
    then
        yay -Sy  --answerclean All --answerdiff None "$@"
    else
        yay -Sy --noconfirm --answerclean All --answerdiff None "$@"
    fi
}

_pacman_install() {
    if [ $INTERACTIVE ]
    then
        _run_as_root pacman -Sy --needed "$@"
    else
        _run_as_root pacman --noconfirm -Sy --needed "$@"
    fi
}

_systemctl() {
    _run_as_root systemctl $1 $2
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
    _pacman_install "${BASE_PACKAGES[@]}" "${KDE_PACKAGES[@]}"
}


install_nordic_theme() {
    _yay_install zafiro-icon-theme-git nordic-kde-git sddm-nordic-theme-git
    plasma-apply-lookandfeel -a Nordic
    /usr/lib/plasma-changeicons Zafiro
}

install_vimium() {
    XPI_PATH="$TMP_INSTALL_FOLDER/vimium.xpi"
    wget -O "$XPI_PATH" "$VIMIUM_URL" 

    for dir in ~/.mozilla/firefox/*.default-release/extensions
    do
        install -Dm644 "$XPI_PATH" "$dir/{d7742d87-e61d-4b78-b8a1-b469842139fa}.xpi"
    done

    rm -f "$XPI_PATH"
}

install_tlp() {
    _pacman_install tlp ethtool smartmontools x86_energy_perf_policy
    if [ $? -eq 0 ]
    then
        _run_as_root systemctl start tlp
        _run_as_root systemctl enable tlp
        _run_as_root systemctl mask systemd-rfkill.socket
        _run_as_root systemctl mask systemd-rfkill.service
    fi
}


#: MacbookPro-specific installation:
#:-----------------------------------:#
mbp_setup_wifi() {
    _run_as_root modprobe -r b43 ssb wl bcma
    _pacman_install broadcom-wl
    _run_as_root modprobe wl
}
