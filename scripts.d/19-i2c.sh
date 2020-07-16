#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Install neccessary packages
apt-get install -y python-smbus libi2c-dev

# Enable i2c interface
sed -i '/^#.*i2c/s/^#//' /boot/config.txt
echo "i2c-dev" >> /etc/modules
echo "i2c-bcm2708" >> /etc/modules
