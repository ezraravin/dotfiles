#!/bin/bash

# Install tmux plugins for all sessions
echo "Installing tmux plugins for all sessions..."
tmux list-sessions | awk '{print $1}' | xargs -I {} tmux run-shell -t {} ~/.tmux/plugins/tpm/bin/install_plugins

# Reload tmux configuration for all sessions
echo "Reloading tmux configuration for all sessions..."
tmux list-sessions | awk '{print $1}' | xargs -I {} tmux source-file ~/.tmux.conf -t {}

echo "tmux configuration reloaded and plugins installed for all sessions!"
