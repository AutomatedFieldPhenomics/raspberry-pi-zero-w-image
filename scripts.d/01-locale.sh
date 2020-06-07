#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Set locale to en_US.UTF-8 for compatibility (not en_CA, sorry)
sed -i "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" /etc/locale.gen
echo 'LANG="en_US.UTF-8"' > /etc/default/locale
dpkg-reconfigure -f noninteractive locales

# Set keyboard layout to us
sed -i "s/^XKBLAYOUT.*/XKBLAYOUT=\"us\"/" /etc/default/keyboard
dpkg-reconfigure -f noninteractive keyboard-configuration
