#!/usr/bin/env sh

sketchybar --add item clock right \
           --set clock label.font="$FONT:Semibold:13.0" \
                       label.color=$LABEL_COLOR \
                       icon.drawing=off \
                       update_freq=10 \
                       script="$PLUGIN_DIR/clock.sh"
