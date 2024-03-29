#!/bin/bash


ROOT_PATH="$(realpath $(dirname $BASH_SOURCE))/.."
source "$ROOT_PATH/utils.sh"

PKG_DATA_PATH="$ROOT_DATA_PATH/i3"
PKG_HOME_PATH="$PKG_DATA_PATH/home"
PKG_COMMON_PATH="$PKG_DATA_PATH/root"


I3_PACKAGES=(
    "i3-gaps" "sddm" "xorg-xinit" "polybar" "nerd-fonts-complete" "rofi"
    "alacritty" "picom" "feh" "xorg-xrandr" "autorandr" "arandr" "scrot"
    "betterlockscreen" "bluez-utils" "playerctl" "mpv" "dunst"
    "alsa-utils" "light" "xss-lock" "papirus-icon-theme" "htop"
    "alsa-lib" "alsa-plugins" "network-manager-applet" "ranger"
    "nordic-theme" "pavucontrol"
)



DE_install_desktop_environment() {
    [ "$EUID" -eq 0 ] && printf "Desktop environment cannot be installed as root.\n" && exit 8

    install_root_files "$PKG_COMMON_PATH"
    link_home_files "$PKG_HOME_PATH"
    yay_install "${I3_PACKAGES[@]}"
}

DE_remove_desktop_environment() {
    [ "$EUID" -eq 0 ] && printf "Desktop environment cannot be uninstalled as root.\n" && exit 8

    rm_root_files "$PKG_COMMON_PATH"
    rm_home_files "$PKG_HOME_PATH"
    yay_uninstall "${I3_PACKAGES[@]}"
}
