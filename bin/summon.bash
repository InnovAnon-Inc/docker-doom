#! /bin/bash
set -exu
[ $# -eq 2 ]
if [ $1 == server ] ; then
  ZANDRONUM="$2-server -host -port 106666"
else
  ZANDRONUM="$2 localhost:10666"
fi

DIR=/home/zandronum/abaddon/wads
# https://stackoverflow.com/questions/1015678/get-most-recent-file-in-a-directory-on-linux
eval "files=($(ls -t --quoting-style=shell-always $DIR))"
if ((${#files[@]} > 0)) ; then
  FILE="-file $DIR/`printf '%s\n' "${files[0]}"`"
else
  FILE=
fi
# TODO fix Abaddon or docker-doom
#      or whatever is breaking the awesome generated maps :'(
FILE=

$ZANDRONUM \
  -waddir /home/zandronum/abaddon/wads \
  -file /home/zandronum/.config/$2/project_brutality.pk3 \
  $FILE \
  +exec "/home/zandronum/config/default.cfg"

