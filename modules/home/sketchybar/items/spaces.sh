#!/usr/bin/env sh

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
    sketchybar --add item "space.$sid" left \
        --subscribe "space.$sid" aerospace_workspace_change \
        --set "space.$sid" \
        icon="$sid" \
        icon.font="$FONT:Bold:14.0" \
        icon.padding_left=10 \
        icon.padding_right=6 \
        icon.highlight_color=$MAGENTA \
        label.font="$APP_FONT" \
        label.color=$GREY \
        label.highlight_color=$WHITE \
        label.padding_left=0 \
        label.padding_right=10 \
        label.drawing=off \
        background.color=$BG1 \
        background.drawing=off \
        click_script="aerospace workspace $sid" \
        script="$PLUGIN_DIR/spaces.sh $sid"
done
