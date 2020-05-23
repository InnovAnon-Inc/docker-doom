#! /bin/bash
set -exu

ZANDRONUM="$PWD/zserv -host -port 106666"

DIR=/home/zandronum/abaddon/wads

# https://stackoverflow.com/questions/1015678/get-most-recent-file-in-a-directory-on-linux
eval "files=($(ls -t --quoting-style=shell-always $DIR))"
if ((${#files[@]} > 0)) ; then
  FILE="`printf '%s\n' "${files[0]}"`"
  cp -v /home/zandronum/abaddon/wads/$FILE .
  FILE="-file $FILE"
else
  FILE=
fi
# TODO fix Abaddon or docker-doom
#      or whatever is breaking the awesome generated maps :'(

cp -v /home/zandronum/wads/freedoom2.wad doom2.wad
cp -v /home/zandronum/wads/Project_Brutality.pk3 \
      /home/zandronum/config/bots.cfg            \
      /home/zandronum/config/zserv.cfg           .
$ZANDRONUM                    \
  -iwad doom2.wad             \
  -waddir $PWD                \
  -file Project_Brutality.pk3 \
  $FILE                       \

#  -file zdaemon.wad           \
#  -config bots.cfg            \
#  -config zserv.cfg

