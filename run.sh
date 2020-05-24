#! /bin/bash
set -exu
[[ $# -eq 0 ]]

sudo             -- \
nice -n +20      -- \
sudo -u `whoami` -- \
docker-compose build

docker push innovanon/docker-doom:latest || :

trap 'docker-compose down' 0

xhost +local:`whoami`
sudo             -- \
nice -n -20      -- \
sudo -u `whoami` -- \
docker-compose up --force-recreate

