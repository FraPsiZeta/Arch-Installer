#!/bin/bash

ROOT_PATH="$(realpath $(dirname $BASH_SOURCE))/.."
source "$ROOT_PATH/utils.sh"


mbp_systemdboot_setup(){
    systemdboot_setup "rw quiet splash acpi_osi=Darwin acpi_mask_gpe=0x06"
}

setup_wifi() {
    modprobe -r b43 ssb wl bcma
    _pacman_install broadcom-wl
    modprobe wl
}


disable_thunderbolt() {
    local tb_sysfs="/sys/bus/pci/devices/0000:07:00.0"

    if grep "thunderbolt" "$tb_sysfs/uevent"
    then
        echo "$tb_sysfs/power/control - - - - auto" > /etc/tmpfiles.d/disable-thunderbolt.conf
    else
        echo "WARNING: Unable to disable thunderbolt controller."
        echo "Apparently it is not in the usual PCI path $tb_sysfs"
    fi
}
