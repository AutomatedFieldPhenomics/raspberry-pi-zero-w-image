#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Changes dtoverlay in config.txt
echo "dtoverlay=dwc2" >> /boot/config.txt

# Adds parameter after rootwait in cmdline.txt
sed -i "s/\(rootwait\)/ \1 modules-load=dwc2,g_ether/" /boot/cmdline.txt
