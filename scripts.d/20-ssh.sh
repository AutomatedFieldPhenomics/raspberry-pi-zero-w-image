#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Enable ssh server
update-rc.d ssh enable

# Disable password authentication
sed -i 's/\#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Add public keys
mkdir /home/pi/.ssh
cat << EOF >> /home/pi/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCdwT5Ftny67046XkMTBUHrC4ajuIHAN0OYNaSGJWsMskVGVRm1jzMeYDZLnRg640eJxC23wEpN3GMTFHCFeciKC1ER7bo5ZlnZc1AxD3rjJNyhac0TKylVlziD4ZnAlrbLAFaoyHJ5Ft6Ed7Kt6Pw3RSYx/wWT6VZKtE2B+P/snYs5fjiYwxW7TQvJ3XcFj5VgQFEG2qPyG3TXUFlwIYmn0rEBQTh1XlFmxa93cTNyC4P8JnJnz4ZDDYsfyy/yAl9fX9/Q+gS+VIc9yX7wNOqOIg6LAizX0Ypn44Xd+G/4xalC6RhHR1tTKNdU6/L9hp8Xe1enqIpEFnbw/S7M60Aqs3oHQeyGKCEwLHKLXsCMqUlETA0o8mu/mBeROwemPcKVPQzqXbAzFLWw6FBAxLf2bsc/4NxFSUcEKafm9RWoVoTc+3qYfUWBgYMjQIOSX5TV2VGkwRcpvnXcXQI0cb9vKV3DblNlz00ywYlhowErix2eFZk8NC8uH1fC6N34yIU= wdconinc@herakles
EOF

# Permissions
chmod 700 /home/pi/.ssh/
chmod 600 /home/pi/.ssh/authorized_keys

