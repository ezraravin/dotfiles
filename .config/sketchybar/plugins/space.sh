#!/bin/bash
# This script updates the space indicators based on the active space
active_space=$(yabai -m query --spaces --space | jq '.index')
for i in {1..10}; do
    if [ "$i" -eq "$active_space" ]; then
        sketchybar --set space.$i background.color=$COLOR_ACCENT
    else
        sketchybar --set space.$i background.color=0x40ffffff
    fi
done
