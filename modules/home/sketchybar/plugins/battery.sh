#!/usr/bin/env bash
DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$DIR/colors.sh"
source "$DIR/icons.sh"

INFO=$(pmset -g batt 2>/dev/null)
CHARGE=$(echo "$INFO" | grep -oE '[0-9]+%' | head -1 | tr -d '%')
[ -z "$CHARGE" ] && CHARGE=100

if echo "$INFO" | grep -q "AC Power"; then
    ICON="$BATTERY_CHARGING"; COLOR=$GREEN
elif [ "$CHARGE" -gt 80 ]; then ICON="$BATTERY_100"; COLOR=$WHITE
elif [ "$CHARGE" -gt 60 ]; then ICON="$BATTERY_75"; COLOR=$WHITE
elif [ "$CHARGE" -gt 40 ]; then ICON="$BATTERY_50"; COLOR=$WHITE
elif [ "$CHARGE" -gt 20 ]; then ICON="$BATTERY_25"; COLOR=$ORANGE
else ICON="$BATTERY_0"; COLOR=$RED
fi

sketchybar --set "$NAME" icon="$ICON" icon.color=$COLOR label="${CHARGE}%"
