#!/usr/bin/env sh

sketchybar --add item wifi right \
           --set wifi icon=$WIFI_CONNECTED \
                     icon.font="$FONT:Regular:15.0" \
                     update_freq=30 \
                     script="$PLUGIN_DIR/wifi.sh" \
           --subscribe wifi wifi_change system_woke
