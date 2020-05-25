#! /bin/bash
set -exu
[[ $# -eq 2 ]]
if   [[ $1 = server ]] ; then
  ZANDRONUM="$2-server -host -port 10668"
elif [[ $1 = client ]] ; then
  ZANDRONUM="$2 192.168.33.10:10668"
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

#[[ "$1" != client ]] || rm -fv .config/zandronum/*
#  -file /home/zandronum/wads/Project_Brutality.pk3 \
#  +exec "/home/zandronum/config/default.cfg"

$ZANDRONUM                                         \
  -iwad /home/zandronum/wads/freedoom2.wad         \
  -waddir /home/zandronum/abaddon/wads             \
  -file /home/zandronum/wads/bd_be.pk3             \
  -file /home/zandronum/wads/rainbow_blood.pk3     \
  $FILE                                            \

