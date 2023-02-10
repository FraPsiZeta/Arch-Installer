#!/bin/bash

. ~/.bashrc

i3-msg 'exec --no-startup-id '"$TERMINAL"' -t "nmtui-float" -e "nmtui"'
