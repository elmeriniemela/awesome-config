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
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
run volumeicon
run xfce4-clipman
run xautolock -time 60 -locker "betterlockscreen -l" -detectsleep

#  disabling energy star features
xset -dpms
# disable screensaver
xset s off
picom -b --config $HOME/.config/awesome/picom.conf