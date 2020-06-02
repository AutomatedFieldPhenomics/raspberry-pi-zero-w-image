#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Enable ssh server
update-rc.d ssh enable

# Disable password authentication
sed -i 's/\#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
