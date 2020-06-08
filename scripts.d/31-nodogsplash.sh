#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Install packages
sudo apt-get install -y libmicrohttpd-dev

# Install nodogsplash
cd /usr/local/src
git clone https://github.com/nodogsplash/nodogsplash.git
cd nodogsplash
make
make install

# Modify settings
sed -i 's|GatewayInterface br-lan|GatewayInterface uap0|' /etc/nodogsplash/nodogsplash.conf

# Install system service
cp /usr/local/src/nodogsplash/debian/nodogsplash.service /lib/systemd/system/
systemctl enable nodogsplash.service
