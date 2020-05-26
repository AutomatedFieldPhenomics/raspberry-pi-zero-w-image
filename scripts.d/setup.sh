#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Update system
#apt update && apt -y -q dist-upgrade

# Install any packages we want
apt install -q -y bash-completion sudo avahi-daemon wpasupplicant

