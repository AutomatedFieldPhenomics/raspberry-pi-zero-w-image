#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Install noVNC and dependencies
apt install novnc websockify python-numpy -y

# Create cron job to start noVNC on boot
CRON_FILE="/var/spool/cron/pi"

touch $CRON_FILE
/usr/bin/crontab $CRON_FILE

/bin/echo "@reboot websockify -D --web=/usr/share/novnc/ 6080 localhost:5901" >> $CRON_FILE 
