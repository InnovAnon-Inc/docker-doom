#! /bin/bash
set -exu
[ $# -eq 2 ]
if   [ $1 = server ] ; then
  ZANDRONUM="$2-server -host -port 10667"
elif [ $1 = client ] ; then
  ZANDRONUM="$2 localhost:10667"
else exit 1 ; fi

PATH=/usr/games:$PATH
DIR=/home/zandronum/abaddon/wads

# https://stackoverflow.com/questions/1015678/get-most-recent-file-in-a-directory-on-linux
eval "files=($(ls -t --quoting-style=shell-always $DIR))"
if ((${#files[@]} > 0)) ; then
  FILE="-file $DIR/`printf '%s\n' "${files[0]}"`"
else
  FILE=
fi

#[ "$1" != client ] || rm -v .config/zandronum/*

$ZANDRONUM                                         \
  -iwad /home/zandronum/wads/freedoom2.wad         \
  -waddir /home/zandronum/abaddon/wads             \
  -file /home/zandronum/wads/Project_Brutality.pk3 \
  $FILE                                            \
  +exec "/home/zandronum/config/default.cfg"

