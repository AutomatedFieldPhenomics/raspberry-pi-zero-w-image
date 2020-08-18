#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Install desktop environment
apt install -y xfce4

# Replace display manager as lightdm does not start properly
apt purge -y lightdm
apt install -y xdm

# Install tools
apt install -y wicd
