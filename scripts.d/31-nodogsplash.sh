#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Nodogsplash version
VERSION=4.5.1

# Install dependencies
sudo apt-get install -q -y libmicrohttpd-dev

# Install nodogsplash
cd /usr/local/src
wget -q https://github.com/nodogsplash/nodogsplash/archive/v${VERSION}.tar.gz
tar -zxvf v${VERSION}.tar.gz
mv nodogsplash-${VERSION} nodogsplash
cd nodogsplash
make
make install

# Modify settings
sed -i 's|GatewayInterface br-lan|GatewayInterface uap0|' /etc/nodogsplash/nodogsplash.conf
sed -i 's|use_outdated_mhd 0|use_outdated_mhd 1|' /etc/nodogsplash/nodogsplash.conf

echo "Press ENTER to continue..."
read

# Install system service
cp /usr/local/src/nodogsplash/debian/nodogsplash.service /lib/systemd/system/
systemctl enable nodogsplash.service
