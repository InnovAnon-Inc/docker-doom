#! /bin/bash
set -exu
[ $# -eq 0 ]
docker-compose build
docker push innovanon/docker-doom:latest || :
docker-compose up --force-recreate

