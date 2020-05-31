#!/bin/bash

# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Based on instructions at https://github.com/billz/raspap-webgui/wiki/Manual-installation

# Install prerequisites
apt-get install -y lighttpd git hostapd dnsmasq openvpn vnstat qrencode php-cgi
# Install iptables-persistent in non-interactive mode
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
apt-get install -y iptables-persistent

# Enable PHP for lighttpd
lighttpd-enable-mod fastcgi-php
systemctl enable lighttpd.service

# Prepare web destination
rm -rf /var/www/html
git clone https://github.com/billz/raspap-webgui /var/www/html

# Allow sudoers access
cp /var/www/html/installers/raspap.sudoers /etc/sudoers.d/090_raspap

# Create configuration directories
mkdir /etc/raspap/
mkdir /etc/raspap/backups
mkdir /etc/raspap/networking
mkdir /etc/raspap/hostapd
mkdir /etc/raspap/lighttpd
mkdir /etc/raspap/openvpn

# dhcpcd.conf as a base config
cat /etc/dhcpcd.conf | tee -a /etc/raspap/networking/defaults > /dev/null

# Auth control file
cp /var/www/html/raspap.php /etc/raspap
# Change the default password (escape $ characters)
pass='\$2y\$10\$h4uP0YcGtd5YHO.DPoZAFeSYaIWwpe8/ZDNok0byFlzmyB4aQAyBe'
sed -i "s|\('admin_pass' => '\).*'|\1$pass'|g" /etc/raspap/raspap.php
# Encrypted with: htpasswd -bnBC 10 "" password | tr -d ':\n' && echo

# Change ownership
chown -R www-data:www-data /var/www/html
chown -R www-data:www-data /etc/raspap

# Hostapd logging and services
mv /var/www/html/installers/*log.sh /etc/raspap/hostapd
mv /var/www/html/installers/service*.sh /etc/raspap/hostapd
# Change ownership and permissions
chown -c root:www-data /etc/raspap/hostapd/*.sh
chmod 750 /etc/raspap/hostapd/*.sh

# Lighttpd control scripts
cp /var/www/html/installers/configport.sh /etc/raspap/lighttpd
chown -c root:www-data /etc/raspap/lighttpd/*.sh

# Raspapd daemon
mv /var/www/html/installers/raspapd.service /lib/systemd/system
systemctl enable raspapd.service

mv /etc/default/hostapd /etc/default_hostapd.old
cp /var/www/html/config/default_hostapd /etc/default/hostapd
cp /var/www/html/config/hostapd.conf /etc/hostapd/hostapd.conf
cp /var/www/html/config/dnsmasq.conf /etc/dnsmasq.d/090_raspap.conf
cp /var/www/html/config/dhcpcd.conf /etc/dhcpcd.conf
cp /var/www/html/config/config.php /var/www/html/includes/

systemctl disable systemd-networkd
cp /var/www/html/config/raspap-bridge-br0.netdev /etc/systemd/network/raspap-bridge-br0.netdev
cp /var/www/html/config/raspap-br0-member-eth0.network /etc/systemd/network/raspap-br0-member-eth0.network


echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/90_raspap.conf

# Set firewall rules
#iptables -t nat -A POSTROUTING -j MASQUERADE
#iptables -t nat -A POSTROUTING -s 192.168.50.0/24 ! -d 192.168.50.0/24 -j MASQUERADE
#iptables-save | tee /etc/iptables/rules.v4

# Enable hostapd service
systemctl unmask hostapd.service
systemctl enable hostapd.service

# Enable openvpn client
sed -i "s/\('RASPI_OPENVPN_ENABLED', \)false/\1true/g" /var/www/html/includes/config.php
systemctl enable openvpn-client@client

cp /var/www/html/installers/configauth.sh /etc/raspap/openvpn/
chown -c root:www-data /etc/raspap/openvpn/*.sh
chmod 750 /etc/raspap/openvpn/*.sh