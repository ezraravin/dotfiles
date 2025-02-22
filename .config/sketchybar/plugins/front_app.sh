#!/bin/bash
front_app=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')
sketchybar --set front_app label="$front_app" label.color=$COLOR_FOREGROUND
