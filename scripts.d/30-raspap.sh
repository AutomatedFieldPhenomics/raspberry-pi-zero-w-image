#!/bin/bash
<<COMMENT
# Setup script error handling see https://disconnected.systems/blog/another-bash-strict-mode for details
set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
IFS=$'\n\t'

# Based on instructions at https://github.com/billz/raspap-webgui/wiki/Manual-installation

# 1. Install lighttpd
apt-get install -y lighttpd php-cgi
# Enable php fastcgi module
lighttpd-enable-mod fastcgi-php
# Enable service
systemctl enable lighttpd.service

# 2. Install iptables-persistent in non-interactive mode
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
apt-get install -y iptables-persistent
# Set firewall rules
cat << EOF > /etc/iptables/rules.v4
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
COMMIT
*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A POSTROUTING -j MASQUERADE
-A POSTROUTING -s 192.168.50.0/24 ! -d 192.168.50.0/24 -j MASQUERADE
COMMIT
EOF
# Forwarding rules
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/90_raspap.conf

# 3. Install dnsmasq
apt-get install -y dnsmasq
# Create config file
cat << EOF > /etc/dnsmasq.d/090_raspap.conf
# RaspAP uap0 configuration for wireless client AP mode
interface=uap0                  # Use interface uap0
bind-interfaces                 # Bind to the interfaces
server=8.8.8.8                  # Forward DNS requests to Google DNS
domain-needed                   # Don't forward short names
bogus-priv                      # Never forward addresses in the non-routed address spaces
dhcp-range=192.168.50.50,192.168.50.150,12h
EOF
# Disable service
systemctl disable dnsmasq.service

# 4. Install RaspAP

# Install prerequisites
apt-get install -y git vnstat qrencode

# Prepare web destination
rm -rf /var/www/html
git clone https://github.com/billz/raspap-webgui /var/www/html

# Allow sudoers access
cp /var/www/html/installers/raspap.sudoers /etc/sudoers.d/090_raspap

# Create configuration directories
mkdir -p /etc/raspap/backups
mkdir -p /etc/raspap/networking
mkdir -p /etc/raspap/hostapd
mkdir -p /etc/raspap/lighttpd
mkdir -p /etc/raspap/openvpn

# Hostapd
apt-get install -y hostapd
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
chmod 750 /etc/raspap/lighttpd/*.sh

# Raspapd daemon
mv /var/www/html/installers/raspapd.service /lib/systemd/system
systemctl enable raspapd.service

# Copy configuration files
cp /var/www/html/config/dhcpcd.conf /etc/dhcpcd.conf
cp /var/www/html/config/config.php /var/www/html/includes/

# Settings for hostapd
cat << EOF > /etc/default/hostapd
DAEMON_CONF="/etc/hostapd/hostapd.conf"
#DAEMON_OPTS=""
EOF
#
cat << EOF > /etc/hostapd/hostapd.conf
driver=nl80211
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
beacon_int=100
auth_algs=1
wpa_key_mgmt=WPA-PSK
ssid=raspi-webgui
channel=1
hw_mode=g
wpa_passphrase=raspberry
interface=uap0
wpa=2
wpa_pairwise=CCMP
country_code=CA
EOF

# Disable networkd
systemctl disable systemd-networkd

# Add Raspberry Pi Zero W AP-STA mode
cat << EOF > /etc/raspap/hostapd.ini
LogEnable = 1
WifiAPEnable = 1
BridgedEnable = 0
WifiManaged = wlan0
EOF

# Hook for wpa_supplicant without interface matching
ln -s /usr/share/dhcpcd/hooks/10-wpa_supplicant /etc/dhcp/dhclient-enter-hooks.d/

cat << EOF > /etc/dhcpcd.conf
# Defaults from Raspberry Pi configuration
hostname
clientid
persistent
option rapid_commit
option domain_name_servers, domain_name, domain_search, host_name
option classless_static_routes
option ntp_servers
require dhcp_server_identifier
slaac private
nohook lookup-hostname
# RaspAP uap0 configuration
interface uap0
static ip_address=192.168.50.1/24
nohook wpa_supplicant
EOF
# dhcpcd.conf as a base config
cp /etc/dhcpcd.conf /etc/raspap/networking/defaults

# Add wlan0 as networking interface
cat << EOF > /etc/raspap/networking/wlan0.ini
interface = wlan0
routers =
ip_address = /INF
domain_name_server =
static = false
failover = false
EOF

# Disable hostapd service (let raspap handle this)
systemctl unmask hostapd.service
systemctl disable hostapd.service

# Install openvpn
apt-get install -y openvpn
# Enable in raspap
#sed -i "s/\('RASPI_OPENVPN_ENABLED', \)false/\1true/g" /var/www/html/includes/config.php
# Setup openvpn scripts
mkdir -p /etc/raspap/openvpn
cp /var/www/html/installers/configauth.sh /etc/raspap/openvpn/
chown -c root:www-data /etc/raspap/openvpn/*.sh
chmod 750 /etc/raspap/openvpn/*.sh
# Disable openvpn client (let raspap handle this)
systemctl disable openvpn-client@client

# Change servicestart.sh
sed -i '/\# Start services/,$d' /etc/raspap/hostapd/servicestart.sh
cat << EOF >> /etc/raspap/hostapd/servicestart.sh
# Start services, mitigating race conditions
echo "Starting network services..."
systemctl start dhcpcd.service
sleep "\${seconds}"
systemctl start hostapd.service
sleep "\${seconds}"
systemctl start dnsmasq.service
sleep "\${seconds}"
if [ \$OPENVPNENABLED -eq 1 ]; then
    systemctl start openvpn-client@client
fi
echo "RaspAP service start DONE"
EOF
COMMENT
