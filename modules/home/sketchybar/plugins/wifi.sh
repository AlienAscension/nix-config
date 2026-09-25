#!/usr/bin/env bash
DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$DIR/colors.sh"
source "$DIR/icons.sh"

if ipconfig getifaddr en0 >/dev/null 2>&1; then
    sketchybar --set "$NAME" icon="$WIFI_CONNECTED" icon.color=$WHITE
else
    sketchybar --set "$NAME" icon="$WIFI_DISCONNECTED" icon.color=$RED
fi
