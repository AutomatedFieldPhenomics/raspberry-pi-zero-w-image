#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Install git
apt-get install -y git

# Get python scripts from github
git clone https://github.com/AutomatedFieldPhenomics/pi-data-scripts /home/pi/bin

# Update scripts daily
cat > /etc/systemd/system/scriptUpdate.service << EOF
[Unit]
Description=Get updated scripts from GitHub

[Service]
Type=simple
ExecStart=/home/pi/updateScripts.sh
EOF

cat > /etc/systemd/system/scriptUpdate.timer << EOF
[Unit]
Description=Updates scripts daily

[Timer]
OnCalendar=daily

[Install]
WantedBy=timers.target
EOF

# Enable update timer
systemctl daemon-reload
systemctl enable scriptUpdate.timer
