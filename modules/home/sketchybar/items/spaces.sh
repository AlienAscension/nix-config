#!/usr/bin/env sh

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
    sketchybar --add item "space.$sid" left \
        --subscribe "space.$sid" aerospace_workspace_change \
        --set "space.$sid" \
        icon="$sid" \
        icon.padding_left=12 \
        icon.padding_right=12 \
        icon.highlight_color=$RED \
        label.drawing=off \
        background.color=0x33ffffff \
        background.corner_radius=6 \
        background.height=24 \
        background.drawing=off \
        click_script="aerospace workspace $sid" \
        script="$PLUGIN_DIR/aerospacer.sh $sid"
done
