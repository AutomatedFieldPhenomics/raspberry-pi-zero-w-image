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

# Reconfigure fonts on boot (fixes font error when using tightVNC)
sed -i '/exit 0/i dpkg-reconfigure xfonts-base' /etc/rc.local

# Create service file for tightVNC see https://gist.github.com/spinxz/1692ff042a7cfd17583b
cat > /etc/systemd/system/vncserver.service << EOF
[Unit]
Description=Remote desktop service (VNC)
After=syslog.target network.target

[Service]
Type=forking
User=pi

ExecStartPre=/bin/sh -c '/usr/bin/vncserver -kill :1 > /dev/null 2>&1 || :'
ExecStart=/usr/bin/vncserver :1
ExecStop=/usr/bin/vncserver -kill :1

[Install]
WantedBy=multi-user.target
EOF

# Enable vncserver.service
systemctl daemon-reload
systemctl enable vncserver.service
