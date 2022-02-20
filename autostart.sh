#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@ &
  fi
}
run nm-applet
run pamac-tray
run variety
run xfce4-power-manager
run blueberry-tray
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
run volumeicon
run xautolock -time 60 -locker "betterlockscreen -l" -detectsleep
run xfce4-clipman


#  disabling energy star features
xset -dpms
# disable screensaver
xset s off
