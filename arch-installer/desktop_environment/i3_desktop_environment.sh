#!/bin/bash


CURRENT_PATH="$(realpath $(dirname $BASH_SOURCE))"
source "$CURRENT_PATH/de_common.sh"

PKG_DATA_PATH="$ROOT_DATA_PATH/i3_data"
PKG_CONFIG_PATH="$PKG_DATA_PATH/config"
PKG_HOME_PATH="$PKG_DATA_PATH/home"
PKG_COMMON_PATH="$PKG_DATA_PATH/common"


I3_PACKAGES=(
    "i3-gaps" "sddm" "xorg-xinit" "polybar" "nerd-fonts-complete" "rofi"
    "alacritty" "picom" "feh" "xorg-xrandr" "autorandr" "arandr" "scrot"
    "betterlockscreen" "bluez-utils" "playerctl" "mpv" "dunst"
    "alsa-utils" "light" "xss-lock" "papirus-icon-theme" "htop"
    "alsa-lib" "alsa-plugins" "network-manager-applet" "ranger"
    "nordic-theme" "pavucontrol"
)



install_desktop_environment() {
    [ "$EUID" -eq 0 ] && printf "Desktop environment cannot be installed as root.\n" && exit 8

    install_root_files "$PKG_COMMON_PATH"
    link_configuration_files "$PKG_CONFIG_PATH"
    link_home_files "$PKG_HOME_PATH"
    yay_install "${I3_PACKAGES[@]}"
}

remove_desktop_environment() {
    [ "$EUID" -eq 0 ] && printf "Desktop environment cannot be uninstalled as root.\n" && exit 8

    rm_root_files "$PKG_COMMON_PATH"
    rm_configuration_files "$PKG_CONFIG_PATH"
    rm_home_dotfiles "$PKG_HOME_PATH"
    yay_uninstall "${I3_PACKAGES[@]}"
}
