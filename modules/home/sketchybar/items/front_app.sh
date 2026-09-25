#!/usr/bin/env sh

sketchybar --add item front_app center \
           --set front_app icon.drawing=off \
                           label.font="$FONT:Bold:12.0" \
                           label.color=$WHITE \
                           background.drawing=on \
                           background.color=$BG1 \
                           script="$PLUGIN_DIR/front_app.sh" \
           --subscribe front_app front_app_switched
