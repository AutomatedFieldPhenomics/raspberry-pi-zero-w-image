#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Install VNC
apt install -y tightvncserver

# Set password
mkdir /home/pi/.vnc
echo "QuITDtCULk8=" | base64 --decode > /home/pi/.vnc/passwd
chmod 600 /home/pi/.vnc/passwd
