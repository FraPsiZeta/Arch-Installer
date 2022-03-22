#!/bin/bash

ROOT_PATH="$(realpath $(dirname $BASH_SOURCE))"
source "$ROOT_PATH/install_arch.sh"
source "$ROOT_PATH/utils.sh"


HOSTNAME="francesco"
USER="francesco"
PASSWORD="root"

set_timezone
generate_locale
add_hosts "$HOSTNAME"
configure_encryption

encrypted_systemdboot_setup "/dev/nvme0n1p1" "/dev/volume/root"

create_user $USER $PASSWORD
change_root_password $PASSWORD
install_base
install_applications
