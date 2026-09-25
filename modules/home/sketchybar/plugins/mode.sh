#!/usr/bin/env bash
DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$DIR/colors.sh"
source "$DIR/icons.sh"

MODE="${MODE:-$(aerospace list-modes --current 2>/dev/null)}"
if [ "$MODE" = "main" ]; then
    sketchybar --set "$NAME" icon="$AEROSPACE_MAIN" background.color=$BLUE label="MAIN"
else
    sketchybar --set "$NAME" icon="$AEROSPACE_SERVICE" background.color=$GREEN \
        label="$(echo "$MODE" | tr '[:lower:]' '[:upper:]')"
fi
