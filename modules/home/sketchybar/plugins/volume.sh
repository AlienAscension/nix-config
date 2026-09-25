#!/usr/bin/env bash
DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$DIR/colors.sh"
source "$DIR/icons.sh"

VOL=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)
MUTED=$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)
[ -z "$VOL" ] && VOL=0

if [ "$MUTED" = "true" ] || [ "$VOL" -eq 0 ]; then ICON="$VOLUME_0"
elif [ "$VOL" -gt 60 ]; then ICON="$VOLUME_100"
elif [ "$VOL" -gt 30 ]; then ICON="$VOLUME_66"
elif [ "$VOL" -gt 10 ]; then ICON="$VOLUME_33"
else ICON="$VOLUME_10"
fi

sketchybar --set "$NAME" icon="$ICON" label="${VOL}%"
