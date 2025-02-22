#!/bin/sh

# Catppuccin Mocha Colors
COLOR_FOREGROUND=0xffcdd6f4
COLOR_RED=0xfff38ba8
COLOR_GREEN=0xffa6e3a1
COLOR_YELLOW=0xfff9e2af

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
    exit 0
fi

case "${PERCENTAGE}" in
9[0-9] | 100)
    ICON="" # Full battery icon
    COLOR=$COLOR_GREEN
    ;;
[6-8][0-9])
    ICON="" # High battery icon
    COLOR=$COLOR_GREEN
    ;;
[3-5][0-9])
    ICON="" # Medium battery icon
    COLOR=$COLOR_YELLOW
    ;;
[1-2][0-9])
    ICON="" # Low battery icon
    COLOR=$COLOR_RED
    ;;
*)
    ICON="" # Critical battery icon
    COLOR=$COLOR_RED
    ;;
esac

if [[ "$CHARGING" != "" ]]; then
    ICON="" # Charging icon
    COLOR=$COLOR_ACCENT
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color=$COLOR label.color=$COLOR_FOREGROUND
