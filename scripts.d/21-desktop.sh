#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Install display server 
apt install -y xserver-xorg

# Install desktop environment
sudo apt install -y xfce4 xfce4-terminal

# Install display manager
apt install -y lightdm
