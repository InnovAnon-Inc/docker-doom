#! /usr/bin/env bash
set -exu
(( $# == 0 ))
cd "`dirname "$(readlink -f "$0")"`"

command -v docker ||
curl https://raw.githubusercontent.com/InnovAnon-Inc/repo/master/get-docker.sh | bash

#XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR}                 \
#sudo --preserve-env=XDG_RUNTIME_DIR             -- \
#nice -n +20                                     -- \
#sudo --preserve-env=XDG_RUNTIME_DIR -u `whoami` -- \
#docker-compose build

sudo             -- \
nice -n +20      -- \
sudo -u `whoami` -- \
docker-compose build

trap 'docker-compose down' 0

xhost +local:`whoami` || :
#XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR}                 \
#sudo --preserve-env=XDG_RUNTIME_DIR             -- \
#nice -n -20                                     -- \
#sudo --preserve-env=XDG_RUNTIME_DIR -u `whoami` -- \
#docker-compose up --force-recreate
sudo             -- \
nice -n -20      -- \
sudo -u `whoami` -- \
docker-compose up --force-recreate

docker-compose push
( #git pull
git add .
git commit -m "auto commit by $0"
git push ) || :

