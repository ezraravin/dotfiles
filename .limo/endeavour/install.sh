#!/bin/bash
# EndeavourOS Setup Script

# Ask for sudo once and keep it alive
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

export MODULES_INSTALL="$HOME/.limo/endeavour/modules"

source "$MODULES_INSTALL/0-dotfiles.sh"
source "$MODULES_INSTALL/1-core.sh"
source "$MODULES_INSTALL/2-display-manager.sh"
source "$MODULES_INSTALL/3-gpu.sh"
source "$MODULES_INSTALL/4-shell.sh"
source "$MODULES_INSTALL/5-dev.sh"
source "$MODULES_INSTALL/5.1-laravel.sh"
source "$MODULES_INSTALL/5.2-rails.sh"
source "$MODULES_INSTALL/6-window-manager.sh"
source "$MODULES_INSTALL/7-tmux.sh"
source "$MODULES_INSTALL/8-apps.sh"
source "$MODULES_INSTALL/9-final.sh"