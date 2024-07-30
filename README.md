<p align="center">
<picture>
<img width="160" height="160"  alt="XPanel" src="https://github.com/iPmartNetwork/iPmart-SSH/blob/main/images/logo.png">
</picture>
  </p> 
<p align="center">
<h2 align="center">Wireguard UI</h2>

A web user interface to manage your WireGuard setup.



## request system 

Ubuntu 22, debian +10

## Features

- Friendly UI
- Authentication
- Manage extra client's information (name, email, etc)
- Retrieve configs using QR code / file

  Feel free to contribute and make this project better!

## Installation - Docker

Before proceeding with the installation of Outline Admin, ensure that `docker` and `docker-compose` are installed on your machine. Follow the instructions below:

```
apt update -y

```
```
apt install docker -y

```

```
apt install docker-compose -y

```

```
apt install golang -y

```
```
git clone https://github.com/iPmartNetwork/wireguard-ui.git

```
```
cd wireguard-ui

```
```
docker compose up --build -d

```
