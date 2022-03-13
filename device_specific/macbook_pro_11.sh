#!/bin/bash

systemdboot_setup(){
    local boot_path="/boot"
    local entry="arch"
    local uuid=$(_find_root_uuid)

    bootctl --path="$boot_path" install
    echo "default $entry" > "$boot_path/loader/loader.conf"
    cat > '"$boot_path/loader/entries/$entry.conf"' <<EOF
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=UUID='"$uuid"' rw quiet splash acpi_osi=Darwin acpi_mask_gpe=0x06
EOF
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
