#!/bin/bash

. ~/.bashrc

i3-msg 'exec --no-startup-id '"$TERMINAL"' -t "htop-float" -e "htop"'
