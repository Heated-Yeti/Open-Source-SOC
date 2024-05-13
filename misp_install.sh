#!/bin/bash

# cloning misp docker
git clone https://github.com/MISP/misp-docker.git
cd misp-docker

# setting "EjQ7A6GK94a0bCdpLRFq6vgfO3V7MyR5kpNocdXp" as the default auth key in the key
line_number=$(grep -n '^ADMIN_KEY=' "./template.env" | cut -d':' -f1)
sed -i "s/\(ADMIN_KEY=\)/\1EjQ7A6GK94a0bCdpLRFq6vgfO3V7MyR5kpNocdXp/" ./template.env

cat << EOF


==========================================================
Make any changes you want to the MISP template file,

to exit,

[ctrl+o] => [enter] => [ctrl+x]
==========================================================

EOF
sleep 3s

nano template.env
mv template.env .env
docker compose pull
docker compose up -d

# retriving the api key
api_key=$(grep "^ADMIN_KEY=" ./.env | cut -d "=" -f 2)

# downloading misp feeds list
wget https://raw.githubusercontent.com/MISP/MISP/2.4/app/files/feed-metadata/defaults.json

# waiting for container to start
for ((i=120;i>=0;i--)){
cat << EOF
===========================================================

Waiting for container to start, $i seconds 

===========================================================
EOF
sleep 1s
clear
}

# adding feeds to misp (defaults.json used with /feeds/importFeeds/ but api present for /feeds/add)
json_payload=$(cat defaults.json)
response=$(curl -XPOST --insecure --header "Authorization: $api_key" --header "Accept: application/json" --header "Content-Type: application/json" -d "${json_payload}" "https://localhost/feeds/importFeeds")
echo "Response: $response"

# marking all feeds as enabled
curl -XPOST --insecure --header "Authorization: $api_key" --header "Accept: application/json" --header "Content-Type: text/html" "https://localhost/feeds/toggleSelected/1/0/%5B1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20%5D"

# misp cron job to automatically update feeds daily (to change the period by use crontab)
curl -XPOST --insecure --header "Authorization: $api_key" --header "Accept: application/json" --header "Content-Type: application/json" https://localhost/feeds/fetchFromAllFeeds
(crontab -l ; echo "0 1 * * * /usr/bin/curl -XPOST --insecure --header "Authorization: $api_key" --header "Accept: application/json" --header "Content-Type: application/json" https://localhost/feeds/fetchFromAllFeeds") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -

cd ..