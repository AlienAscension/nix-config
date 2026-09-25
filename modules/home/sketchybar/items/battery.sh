#!/usr/bin/env sh

sketchybar --add item battery right \
           --set battery icon=$BATTERY_100 \
                         icon.font="$FONT:Regular:16.0" \
                         update_freq=120 \
                         script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery power_source_change system_woke
