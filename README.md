<p align="center"> 
    <img src="extra/logo/logo.svg" width="200" alt="Outline Logo"> 
</p>

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
cd wireguard-ui.git

```
```
docker-compose up -d

```
