#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Install VNC
apt install -y realvnc-vnc-server realvnc-vnc-viewer

# Enable VNC
systemctl enable vncserver-x11-serviced.service 
systemctl start vncserver-x11-serviced.service

# Start VNC server at boot
sed -i '/^# Print/i vncserver' /etc/rc.local

