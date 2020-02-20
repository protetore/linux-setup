#!/usr/bin/env bash

source ~/.definition

DOCKER_NET_ADDR=10.99.10.0/24

# Use docker without sudo
sudo usermod -aG docker $USER
newgrp
sudo systemctl restart docker

# Create a network so container can communicate by name
docker network create --subnet=$DOCKER_NET_ADDR  $DOCKER_NET

# Postgresql
docker exec -it -d --name=postgres\
    --net=$DOCKER_NET \
    --dns-search=$DOCKER_NET \
    --restart=always \
    -p 5432:5432 \
    -e POSTGRES_PASSWORD=12345678 \
    postgres:alpine
    
# PgAdmin4
docker exec -it -d --name=pgadmin\
    --net=$DOCKER_NET \
    --dns-search=$DOCKER_NET \
    --restart=always \
    -p 5050:5050 \
    chorss/docker-pgadmin4

