#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Install dnsmasq
apt-get install -y dnsmasq

# Assign fixed IP address to usb0
cat << EOF >> /etc/dhcpcd.conf
# usb0 configuration
interface usb0
static ip_address=192.168.40.1/24
EOF

# Allcoate dhcp addresses to usb0
cat << EOF > /etc/dnsmasq.d/090_usb0.conf
interface=usb0                  # Use interface usb0
bind-interfaces                 # Bind to the interfaces
server=8.8.8.8                  # Forward DNS requests to Google DNS
domain-needed                   # Don't forward short names
bogus-priv                      # Never forward addresses in the non-routed address spaces
dhcp-range=192.168.40.50,192.168.40.150,12h
EOF
