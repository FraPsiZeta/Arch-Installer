#!/bin/bash

ROOT_PATH="$(realpath $(dirname $BASH_SOURCE))/.."
source "$ROOT_PATH/utils.sh"

PKG_DATA_PATH="$ROOT_DATA_PATH/sway_data"
PKG_CONFIG_PATH="$PKG_DATA_PATH/config"
PKG_HOME_PATH="$PKG_DATA_PATH/home"
PKG_COMMON_PATH="$PKG_DATA_PATH/common"

SWAY_PACKAGES=(
    "sway" "fzf" "swaybg" "swayidle" "swaylock" "xorg-xwayland" "waybar"
    "nerd-fonts" "alacritty" "feh" "grim" "slurp" "jq" "xorg-xwayland"
    "bluez-utils" "playerctl" "mpv" "dunst" "wl-clipboard" "chromium"
    "alsa-utils" "light" "papirus-icon-theme" "htop" "sway-launcher-desktop"
    "alsa-lib" "alsa-plugins" "network-manager-applet" "ranger" "dragon-drop"
    "nordic-theme" "pavucontrol" "xdg-desktop-portal-wlr"
)


DE_install_desktop_environment() {
    [ "$EUID" -eq 0 ] && printf "Desktop environment cannot be installed as root.\n" && exit 8

    install_root_files "$PKG_COMMON_PATH"
    link_configuration_files "$PKG_CONFIG_PATH"
    yay_install "${SWAY_PACKAGES[@]}"
}

DE_remove_desktop_environment() {
    [ "$EUID" -eq 0 ] && printf "Desktop environment cannot be uninstalled as root.\n" && exit 8

    rm_root_files "$PKG_COMMON_PATH"
    rm_configuration_files "$PKG_CONFIG_PATH"
    yay_uninstall "${SWAY_PACKAGES[@]}"
}
