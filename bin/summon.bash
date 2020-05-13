#! /bin/bash
set -exu

DIR=/home/zandronum/abaddon/wads
# https://stackoverflow.com/questions/1015678/get-most-recent-file-in-a-directory-on-linux
eval "files=($(ls -t --quoting-style=shell-always $DIR))"
if ((${#files[@]} > 0)) ; then
  FILE="-file $DIR/`printf '%s\n' "${files[0]}"`"
else
  FILE=
fi

zandronum-server \
  -host \
  -port 10666 \
  -waddir /home/zandronum/abaddon/wads \
  $FILE \
  +exec "/home/zandronum/config/default.cfg"

