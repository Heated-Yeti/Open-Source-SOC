#!/bin/bash

# Installing Shuffle
git clone https://github.com/Shuffle/Shuffle
cd Shuffle

# Fix prerequisites for the Opensearch database (Elasticsearch):
mkdir shuffle-database                    
sudo chown -R 1000:1000 shuffle-database  # IF you get an error using 'chown', add the user first with 'sudo useradd opensearch'
sudo swapoff -a                           # Disable swap

# setting username and password
sed -i "s/\(SHUFFLE_DEFAULT_USERNAME=\)/\1admin/" ./.env
sed -i "s/\(SHUFFLE_DEFAULT_PASSWORD=\)/\1admin/" ./.env

# Run docker-compose.
docker compose up -d