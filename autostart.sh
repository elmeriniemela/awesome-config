#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@ &
  fi
}
run nm-applet
run aarchup --aur --loop-time 60
run blueberry-tray
run lxsession
run xfce4-clipman
run xautolock -time 60 -locker $HOME/.config/awesome/scripts/locker.sh -detectsleep
run picom -b --config $HOME/.config/awesome/picom.conf

#  disabling energy star features
xset -dpms
# disable screensaver
xset s off