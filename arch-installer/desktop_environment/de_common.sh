#!/bin/bash

ROOT_PATH="$(realpath $(dirname $BASH_SOURCE))/.."
source "$ROOT_PATH/utils.sh"

#: $1 Source config folder to link from
link_configuration_files() {
    link_dir "$1" "$HOME/.config"
}

#: $1 Source config folder to copy from
install_configuration_files() {
    install_dir "$1" "$HOME/.config"
}

#: $1 Source config folder 
rm_configuration_files() {
    uninstall_dir "$1" "$HOME/.config"
}

#: $1 Source config folder to copy from
install_root_files() {
    sudo_install_dir "$1" "/"
}

rm_root_files() {
    sudo_uninstall_dir "$1" "/"
}

link_home_dotfiles() {
    link_dir "$1" "$HOME"
}

install_home_dotfiles() {
    install_dir "$1" "$HOME"
}

rm_home_dotfiles() {
    uninstall_dir "$1" "$HOME"
}
