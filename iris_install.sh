#!/bin/bash

#  Clone the iris-web repository
git clone https://github.com/dfir-iris/iris-web.git
cd iris-web

# Checkout to the last tagged version
git checkout v2.4.7

# Setting admininstrator password
sed -i "s/#IRIS_ADM_PASSWORD=/IRIS_ADM_PASSWORD=/" ./.env.model

# Copy the environment file
cp .env.model .env

# Build the dockers
docker compose build

# Run IRIS
docker compose up -d

cd ..