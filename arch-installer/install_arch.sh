#!/bin/bash

ROOT_PATH="$(realpath $(dirname $BASH_SOURCE))"
source "$ROOT_PATH/utils.sh"


set_timezone() {
    local region=${1:-Europe}
    local city=${2:-Rome}
    ln -sf /usr/share/zoneinfo/"$region"/"$city" /etc/localtime
    hwclock --systohc
}


generate_locale() {
    local locale=${1:-"en_US.UTF-8 UTF-8"}
    local lang=$(echo "$locale" | cut -d' ' -f1)

    sed -i "s/#$locale/$locale/g" /etc/locale.gen
    locale-gen

    echo "LANG=$lang" > /etc/locale.conf
}


configure_encryption() {
    pacman_install lvm2
    sed -i 's/HOOKS=(\([^)]\))/HOOKS=(\1 encrypt lvm2)/g' /etc/mkinitcpio.conf
    mkinitcpio -p linux
}


# $1: hostname
add_hosts() {
    [ -z $1 ] && printf "ERROR: hostname needed for function 'add_hosts'\n" && exit 5

    cat $1 > /etc/hostname
    cat > /etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   myhostname.localdomain $1
EOF
}

# $1: Password
change_root_password() {
    echo root:$1 | chpasswd
}

# $1: Username
# $2: Password
create_user() {
    useradd -m -G wheel,video $1
    echo $1:$2 | chpasswd
}


