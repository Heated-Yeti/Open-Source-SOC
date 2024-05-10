git clone https://github.com/MISP/misp-docker.git
cd misp-docker
cat << EOF


==========================================================
Make any changes you want to the MISP template file,

to exit,

[ctrl+o] => [enter] => [ctrl+x]
==========================================================

EOF
nano template.env
mv template.env .env
docker compose pull
docker compuse up -d