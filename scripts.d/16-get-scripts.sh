#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Install git
apt-get install git

# Get python scripts from github
git clone https://github.com/AutomatedFieldPhenomics/pi-data-scripts /home/pi/bin
