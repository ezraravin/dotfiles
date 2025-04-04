#!/bin/bash
brightnessctl --monitor | while read -r _; do
  pkill -RTMIN+8 waybar # Refresh Waybar on brightness change
done
