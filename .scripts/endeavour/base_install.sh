#!/bin/bash
# Simple System Setup Script

# Dotfiles setup
echo "Setting up dotfiles..."
if [ ! -d "$HOME/dotfiles" ]; then
  git clone https://gitlab.com/ezraravinmateus/dotfiles.git "$HOME/dotfiles" &&
    cp -r "$HOME/dotfiles/." "$HOME/" &&
    rm -rf "$HOME/dotfiles" &&
    echo "Dotfiles installed" ||
    echo "Failed to install dotfiles"
else
  echo "Dotfiles already exist - skipping"
fi

# Git setup
echo "Setting up Git..."
if ! git config --global user.email &>/dev/null; then
  read -p "Git email: " git_email
  read -p "Git name: " git_name
  git config --global user.email "$git_email"
  git config --global user.name "$git_name"
  git config --global init.defaultBranch main
  echo "Git configured"
else
  echo "Git already configured - skipping"
fi

# System setup
echo "Setting up system..."
sudo systemctl enable --now bluetooth

# Reboot prompt
read -p "Reboot now? (y/n): " choice
if [[ "$choice" =~ ^[Yy]$ ]]; then
  sudo reboot
else
  echo "Done! Reboot recommended."
fi
