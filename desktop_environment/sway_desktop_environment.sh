#!/bin/bash

ROOT_PATH="$(realpath $(dirname $BASH_SOURCE))/.."
source "$ROOT_PATH/utils.sh"

PKG_DATA_PATH="$ROOT_PATH/sway_data"

PKG_CONFIG_PATH="$PKG_DATA_PATH/config"
PKG_HOME_PATH="$PKG_DATA_PATH/home"
PKG_COMMON_PATH="$PKG_DATA_PATH/common"

HOME_CONFIG_PATH="$HOME/.config"


SWAY_PACKAGES=(
    "sway" "fzf" "swaybg" "swayidle" "swaylock" "xorg-xwayland" "waybar"
    "nerd-fonts-complete" "alacritty" "feh"  "grim" "slurp" "jq"
    "bluez-utils" "playerctl" "mpv" "dunst" "wl-clipboard"
    "alsa-utils" "light" "papirus-icon-theme" "htop"
    "alsa-lib" "alsa-plugins" "network-manager-applet" "ranger" "dragon-drop"
    "nordic-theme" "pavucontrol"
)


_install_configuration_files() {
    link_dir "$PKG_CONFIG_PATH" "$HOME_CONFIG_PATH"
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
    link_dir "$PKG_HOME_PATH" "$HOME"
}

_rm_home_dotfiles() {
    uninstall_dir "$PKG_HOME_PATH" "$HOME"
}

_install_packages() {
    yay_install "${SWAY_PACKAGES[@]}"
}

_rm_packages() {
    yay_uninstall "${SWAY_PACKAGES[@]}"
}

install_desktop_environment() {
    [ "$EUID" -eq 0 ] && printf "Desktop environment cannot be installed as root.\n" && exit 8

    _install_common_files
    _install_configuration_files
    _install_packages
}

remove_desktop_environment() {
    [ "$EUID" -eq 0 ] && printf "Desktop environment cannot be uninstalled as root.\n" && exit 8

    _rm_common_files
    _rm_configuration_files
    _rm_packages
}
