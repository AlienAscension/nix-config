#!/usr/bin/env sh

sketchybar --add item volume right \
           --set volume icon=$VOLUME_100 \
                        icon.font="$FONT:Regular:15.0" \
                        update_freq=10 \
                        script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change
