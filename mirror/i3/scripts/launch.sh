#!/bin/bash

# (Re)launch polybar
pkill polybar
polybar bar &

# Restore the wallpaper
nitrogen --restore &

# Start polkit-gnome
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Start picom
pkill picom
picom &