#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Install VNC
apt install -y realvnc-vnc-server

# Create startup file
#cat > /etc/systemd/system/tightvncserver.service << EOF
#[Unit]
#Description=TightVNC remote desktop server
#After=sshd.service

#[Service]
#Type=dbus
#ExecStart=/usr/bin/tightvncserver :1
#User=pi
#Type=forking

#[Install]
#WantedBy=multi-user.target
#EOF

# Change ownership of and make executable the startup file
#chown root:root /etc/systemd/system/tightvncserver.service
#chmod 755 /etc/systemd/system/tightvncserver.service

# Enable startup at boot
#systemctl enable tightvncserver.service
