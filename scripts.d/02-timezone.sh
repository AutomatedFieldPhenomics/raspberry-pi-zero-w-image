#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Create link
echo "America/Winnipeg" > /etc/timezone
ln -sf /usr/share/zoneinfo/America/Winnipeg /etc/localtime
dpkg-reconfigure -f noninteractive tzdata
