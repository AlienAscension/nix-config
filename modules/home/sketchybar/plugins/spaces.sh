#!/usr/bin/env bash
DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$DIR/icons.sh"

SID="$1"
APPS=$(aerospace list-windows --workspace "$SID" --format '%{app-name}' 2>/dev/null)

ICONS=""
while IFS= read -r app; do
    [ -z "$app" ] && continue
    ICONS="$ICONS$(bash "$DIR/plugins/icon_map.sh" "$app")"
done <<< "$APPS"

if [ -n "$ICONS" ]; then LABEL_DRAW=on; else LABEL_DRAW=off; fi

if [ "$SID" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set "$NAME" \
        background.drawing=on \
        icon.highlight=on \
        label.highlight=on \
        label.drawing=$LABEL_DRAW \
        label="$ICONS"
else
    sketchybar --set "$NAME" \
        background.drawing=off \
        icon.highlight=off \
        label.highlight=off \
        label.drawing=$LABEL_DRAW \
        label="$ICONS"
fi
