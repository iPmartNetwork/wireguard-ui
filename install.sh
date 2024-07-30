#!/bin/bash

# Update package lists
echo "Updating package lists..."
sudo apt update -y

# Upgrade installed packages
echo "Upgrading installed packages..."
sudo apt upgrade -y

echo 'net.ipv4.ip_forward=1' | tee -a /etc/sysctl.conf


# Confirm completion
echo "System update and upgrade complete."

# Installation of Wireguard
echo "Installation of Wireguard"
apt install wireguard -y 

# Downloading Wireguard UI and extract it
echo "Downloading UI"
wget -P /tmp https://github.com/ngoduykhanh/wireguard-ui/releases/download/v0.6.0/wireguard-ui-v0.6.0-darwin-amd64.tar.gz
echo "extracting wireguard-ui"
tar -xzvf /tmp/wireguard-ui-*.tar.gz -C /tmp

echo "creation of the folder wireguard-ui"
mkdir -p /opt/wireguard-ui

echo "Moving extracted files to /opt/wireguard-ui.."
mv /tmp/wireguard-ui /opt/wireguard-ui

# Check if ufw already exist 
if dpkg -l | grep -q ufw; then
    echo "UFW already exists."

else 
    echo "UFW isn't installed. Installing UFW..."
    apt install ufw -y 
fi

# UFW Rules 
echo "Opening of port 443"
ufw allow 443
echo "Opening of port 80"
ufw allow 80
echo "opening of port 5000"
ufw allow 5000
echo "opening of port 51820"
ufw allow 51820
ufw enable

# Creating and configuration of a .env
echo "var1=WGUI_USERNAME=admin" | tee /opt/wireguard-ui/.env > /dev/null
echo "var2=WGUI_PASSWORD=admin" | tee -a /opt/wireguard-ui/.env > /dev/null

# Creating two files .sh
cat <<EOF > /opt/wireguard-ui/postdown.sh
#!/usr/bin/bash
ufw route allow in on wg0 out on <INTERFACE>
iptables -t nat -I POSTROUTING -o <INTERFACE> -j MASQUERADE
EOF

cat <<EOF > /opt/wireguard-ui/postup.sh
#!/usr/bin/bash
ufw route delete allow in on wg0 out on <INTERFACE>
iptables -t nat -D POSTROUTING -o <INTERFACE> -j MASQUERADE
EOF

#Authorize execution
chmod +x /opt/wireguard-ui/post*.sh 

cat <<EOF > /etc/systemd/system/wireguard-ui-daemon.service
[Unit]
Description=WireGuard UI Daemon
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=simple
WorkingDirectory=/opt/wireguard-ui
EnvironmentFile=/opt/wireguard-ui/.env
ExecStart=/opt/wireguard-ui/wireguard-ui -bind-address "adresse IP:5000"

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF > /etc/systemd/system/wgui.service
[Unit]
Description=Restart WireGuard
After=network.target
	
[Service]
Type=oneshot
ExecStart=/usr/bin/systemctl restart wg-quick@wg0.service

[Install]
RequiredBy=wgui.path
EOF

cat <<EOF > /etc/systemd/system/wgui.path
[Unit]
Description=Watch /etc/wireguard/wg0.conf for changes

[Path]
PathModified=/etc/wireguard/wg0.conf

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable wgui.{path,service}
systemctl start wgui.{path,service}
