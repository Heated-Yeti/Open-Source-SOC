#!/bin/bash

# Cloning Wazuh
git clone https://github.com/wazuh/wazuh-docker.git -b v4.7.4
cd "./wazuh-docker/single-node/" 

# Increasing memory max count
sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" >> /etc/sysctl.conf

# Generating certificates
docker compose -f generate-indexer-certs.yml run --rm generator

# Chaning compose ports and increasing memory
sed -i 's/443:5601/5500:5601/' docker-compose.yml
sed -i 's/9200:9200/9201:9200/' docker-compose.yml
sed -i 's/514:514\/udp/5140:514\/udp/' docker-compose.yml
sed -i "s/\(\"- OPENSEARCH_JAVA_OPTS=-Xms1g -\)/\1Xmx4g\"/" docker-compose

docker compose up -d