#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@ &
  fi
}
run nm-applet
run blueman-applet
run lxpolkit
run xfce4-clipman
run xss-lock -- $HOME/.config/awesome/scripts/locker.sh
run picom -b --config $HOME/.config/awesome/picom.conf

# Convenience
# run slack
# run thunderbird
# run brave

#  disabling energy star features
xset -dpms
# Lock after one hour of inactivity.
xset s 3600
