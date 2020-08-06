#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Install noVNC and dependencies
apt install novnc websockify python-numpy

# Create service file for noVNC
cat > /etc/systemd/system/novnc.service << EOF
[Unit]
Description=VNC client web application
After=syslog.target network.target vncserver.service

[Service]
Type=forking
User=pi

ExecStart=/usr/bin/websockify -D --web=/usr/share/novnc/ 6080 localhost:5901

[Install]
WantedBy=multi-user.target
EOF

# Enable service
systemctl daemon-reload
systemctl enable novnc.service
