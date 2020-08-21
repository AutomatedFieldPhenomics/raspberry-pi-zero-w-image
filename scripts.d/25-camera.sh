#!/bin/bash
  
# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Enable camera interface
echo "start_x=1" >> /boot/config.txt
echo "gpu_mem=128" >> /boot/config.txt
