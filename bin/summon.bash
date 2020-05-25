#! /bin/bash
set -exu
[[ $# -eq 1 ]]
if   [[ "$1" = server ]] ; then
ZANDRONUM="$PWD/zserv -host -port 106666"
elif [[ "$1" = client ]] ; then
ZANDRONUM="$PWD/zdaemon 192.168.66.10:10667"

#wine zdaemon11012-setup.exe
#else exit 1 ; fi

# https://stackoverflow.com/questions/1015678/get-most-recent-file-in-a-directory-on-linux
eval "files=($(ls -t --quoting-style=shell-always /home/zandronum/abaddon/wads))"
if ((${#files[@]} > 0)) ; then
  FILE="`printf '%s\n' "${files[0]}"`"
  cp -v /home/zandronum/abaddon/wads/$FILE .
  FILE="-file $FILE"
else
  FILE=
fi

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

