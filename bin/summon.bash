#! /bin/bash
set -exu
[ $# -eq 1 ]
if [ $1 == server ] ; then
  ZANDRONUM='zandronum-server -host'
else
  ZANDRONUM=zandronum
fi

DIR=/home/zandronum/abaddon/wads
# https://stackoverflow.com/questions/1015678/get-most-recent-file-in-a-directory-on-linux
eval "files=($(ls -t --quoting-style=shell-always $DIR))"
if ((${#files[@]} > 0)) ; then
  FILE="-file $DIR/`printf '%s\n' "${files[0]}"`"
else
  FILE=
fi

$ZANDRONUM \
  -port 10666 \
  -waddir /home/zandronum/abaddon/wads \
  $FILE \
  +exec "/home/zandronum/config/default.cfg"
