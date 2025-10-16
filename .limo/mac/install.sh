#!/bin/bash

export MODULES_INSTALL="$HOME/.limo/mac/modules"

# Extend sudo timeout for the entire script
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" 2>/dev/null || exit
done &

source "$MODULES_INSTALL/000-git.sh"
source "$MODULES_INSTALL/001-brew.sh"
source "$MODULES_INSTALL/002-mac.sh"
source "$MODULES_INSTALL/003-dev.sh"

echo "✅ Setup complete"
