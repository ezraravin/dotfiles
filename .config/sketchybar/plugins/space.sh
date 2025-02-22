#!/bin/bash

# Catppuccin Mocha Colors
COLOR_ACCENT=0xff89b4fa
COLOR_INACTIVE=0x40ffffff

# Get the focused workspace using Aerospace
active_space=$(aerospace list-workspaces --focused --format "%{workspace}")

# Check if active_space is a valid integer
if [[ -z "$active_space" || ! "$active_space" =~ ^[0-9]+$ ]]; then
    echo "Error: Unable to determine active workspace."
    exit 1
fi

# Update the space indicators
for i in {1..10}; do
    if [ "$i" -eq "$active_space" ]; then
        sketchybar --set space.$i background.color=$COLOR_ACCENT
    else
        sketchybar --set space.$i background.color=$COLOR_INACTIVE
    fi
done
