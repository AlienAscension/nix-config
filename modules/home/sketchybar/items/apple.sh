#!/usr/bin/env sh

POPUP_OFF="sketchybar --set apple.logo popup.drawing=off"
POPUP_CLICK="sketchybar --set \$NAME popup.drawing=toggle"

sketchybar --add item apple.logo left \
           --set apple.logo icon=$APPLE \
                            icon.font="$FONT:Black:16.0" \
                            icon.color=$GREEN \
                            background.drawing=off \
                            background.padding_right=4 \
                            label.drawing=off \
                            click_script="$POPUP_CLICK" \
           --add item apple.settings popup.apple.logo \
           --set apple.settings icon=$GEAR \
                                icon.color=$ICON_COLOR \
                                background.drawing=off \
                                label="System Settings" \
                                click_script="open -a 'System Settings'; $POPUP_OFF" \
           --add item apple.activity popup.apple.logo \
           --set apple.activity icon=$CPU \
                                icon.color=$ICON_COLOR \
                                background.drawing=off \
                                label="Activity Monitor" \
                                click_script="open -a 'Activity Monitor'; $POPUP_OFF" \
           --add item apple.lock popup.apple.logo \
           --set apple.lock icon=$LOCK \
                            icon.color=$ICON_COLOR \
                            background.drawing=off \
                            label="Lock Screen" \
                            click_script="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend; $POPUP_OFF" \
           --add item apple.sleep popup.apple.logo \
           --set apple.sleep icon=$POWER \
                            icon.color=$ICON_COLOR \
                            background.drawing=off \
                            label="Sleep Displays" \
                            click_script="pmset displaysleepnow; $POPUP_OFF"
