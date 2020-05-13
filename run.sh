#! /bin/bash
set -exu
[ $# -eq 0 ]
docker-compose build
docker-compose up --force-recreate
