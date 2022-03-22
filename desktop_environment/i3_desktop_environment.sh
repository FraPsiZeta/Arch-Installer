#!/bin/bash

ROOT_PATH="$(realpath $(dirname $BASH_SOURCE))/.."
source "$ROOT_PATH/utils.sh"

PKG_DATA_PATH="$ROOT_PATH/i3_data"

PKG_CONFIG_PATH="$PKG_DATA_PATH/config"
PKG_HOME_PATH="$PKG_DATA_PATH/home"
PKG_COMMON_PATH="$PKG_DATA_PATH/common"

HOME_CONFIG_PATH="$HOME/.config"


I3_PACKAGES=(
    "i3-gaps" "sddm" "xorg-xinit" "polybar" "nerd-fonts-complete" "rofi"
    "alacritty" "picom" "feh" "xorg-xrandr" "autorandr" "scrot"
    "betterlockscreen" "bluez-utils" "playerctl" "mpv" "dunst"
    "alsa-utils" "light" "xss-lock" "papirus-icon-theme" "htop"
    "alsa-lib" "alsa-plugins" "network-manager-applet" "ranger"
)


_install_configuration_files() {
    install_dir "$PKG_CONFIG_PATH" "$HOME_CONFIG_PATH"
}

_rm_configuration_files() {
    uninstall_dir "$PKG_CONFIG_PATH" "$HOME_CONFIG_PATH"
}

_install_common_files() {
    sudo_install_dir "$PKG_COMMON_PATH" "/"
}

_rm_common_files() {
    sudo_uninstall_dir "$PKG_COMMON_PATH" "/"
}

_install_home_dotfiles() {
    install_dir "$PKG_HOME_PATH" "$HOME"
}

_rm_home_dotfiles() {
    uninstall_dir "$PKG_HOME_PATH" "$HOME"
}

_install_packages() {
    yay_install "${I3_PACKAGES[@]}"
}

_rm_packages() {
    yay_uninstall "${I3_PACKAGES[@]}"
}

install_desktop_environment() {
    [ "$EUID" -eq 0 ] && printf "Desktop environment cannot be installed as root.\n" && exit 8

    _install_common_files
    _install_configuration_files
    _install_home_dotfiles
    _install_packages
}

remove_desktop_environment() {
    [ "$EUID" -eq 0 ] && printf "Desktop environment cannot be uninstalled as root.\n" && exit 8

    _rm_common_files
    _rm_configuration_files
    _rm_home_dotfiles
    _rm_packages
}
