#!/usr/bin/env sh

sketchybar --add item aerospace_mode left \
           --set aerospace_mode icon=$AEROSPACE_MAIN \
                                icon.color=$BLACK \
                                icon.padding_left=8 \
                                icon.padding_right=4 \
                                label.color=$BLACK \
                                label.font="$FONT:Black:11.0" \
                                label.padding_right=8 \
                                background.color=$BLUE \
                                background.drawing=on \
                                script="$PLUGIN_DIR/mode.sh" \
           --subscribe aerospace_mode aerospace_mode_change
