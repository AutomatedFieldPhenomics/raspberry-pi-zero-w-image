#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Create reconfigure fonts service
cat > /etc/systemd/system/reconfigure.service << EOF
[Unit]
Description=Reconfigure xfonts-base
Before=vncserver.service

[Service]
Type=simple
ExecStart=/usr/sbin/dpkg-reconfigure xfonts-base

[Install]
WantedBy=multi-user.target
EOF
