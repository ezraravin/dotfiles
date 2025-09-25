#!/bin/bash
WALLPAPER_DIR="$HOME/.config/backgrounds"

# Get all monitor names dynamically
MONITORS=$(hyprctl monitors -j | jq -r '.[] | .name')

# Unload existing wallpapers first
hyprctl hyprpaper unload all

# Store selected wallpapers to avoid duplicates (optional)
declare -A SELECTED_WALLPAPERS

# Process each monitor
for MONITOR in $MONITORS; do
  # Find all wallpapers (excluding currently selected ones)
  WALLPAPERS=$(find "$WALLPAPER_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" \))
  
  # Remove already-selected wallpapers from the list (if avoiding duplicates)
  for used_wp in "${SELECTED_WALLPAPERS[@]}"; do
    WALLPAPERS=$(echo "$WALLPAPERS" | grep -v "$used_wp")
  done
  
  # Select random wallpaper
  RANDOM_WALLPAPER=$(echo "$WALLPAPERS" | shuf -n 1)
  
  # Store selection if avoiding duplicates
  SELECTED_WALLPAPERS["$MONITOR"]=$RANDOM_WALLPAPER

  # Preload and apply with delay
  hyprctl hyprpaper preload "$RANDOM_WALLPAPER"
  sleep 0.1  # Small delay between commands
  hyprctl hyprpaper wallpaper "$MONITOR,$RANDOM_WALLPAPER"
  sleep 0.1  # Allow time for processing
done
