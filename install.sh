#!/bin/bash
# install docker
apt-get update
apt-get install -y curl
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
apt-get update

apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose wireguard
systemctl start docker
systemctl enable docker
mkdir /root/wgs
cd /root/wgs
cat > /root/wgs/docker-compose.yaml << EOF
version: "3"
services:
  wireguard:
    image: linuxserver/wireguard:legacy-v1.0.20210914-ls22
    container_name: wireguard
    cap_add:
      - NET_ADMIN
    volumes:
      - ./config:/config
    ports:
      # port for wireguard-ui. this must be set here as the `wireguard-ui` container joins the network of this container and hasn't its own network over which it could publish the ports
      - "5000:5000"
      # port of the wireguard server
      - "51820:51820/udp"
    restart: always
  wireguard-ui:
    image: ngoduykhanh/wireguard-ui:latest
    container_name: wireguard-ui
    depends_on:
      - wireguard
    cap_add:
      - NET_ADMIN
    # use the network of the 'wireguard' service. this enables to show active clients in the status page
    network_mode: service:wireguard
    environment:
      - SENDGRID_API_KEY
      - EMAIL_FROM_ADDRESS
      - EMAIL_FROM_NAME
      - SESSION_SECRET
      - WGUI_USERNAME=admin
      - WGUI_PASSWORD=admin
      - WG_CONF_TEMPLATE
      - WGUI_MANAGE_START=true
      - WGUI_MANAGE_RESTART=true
      - WGUI_DNS=94.140.14.14,94.140.15.15
      - WGUI_SERVER_POST_UP_SCRIPT=iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
      - WGUI_SERVER_POST_DOWN_SCRIPT=iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
    logging:
      driver: json-file
      options:
        max-size: 50m
    volumes:
      - ./db:/app/db
      - ./config:/etc/wireguard
    restart: always
EOF

docker-compose up -d
