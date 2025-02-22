#!/bin/sh

# Catppuccin Mocha Colors
COLOR_FOREGROUND=0xffcdd6f4
COLOR_ACCENT=0xff89b4fa

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

if [ "$SENDER" = "volume_change" ]; then
    VOLUME="$INFO"

    case "$VOLUME" in
    [6-9][0-9] | 100)
        ICON="󰕾" # High volume icon
        ;;
    [3-5][0-9])
        ICON="󰖀" # Medium volume icon
        ;;
    [1-9] | [1-2][0-9])
        ICON="󰕿" # Low volume icon
        ;;
    *)
        ICON="󰖁" # Muted volume icon
        ;;
    esac

    sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%" icon.color=$COLOR_ACCENT label.color=$COLOR_FOREGROUND
fi
