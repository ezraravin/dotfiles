#!/bin/bash
# Simple System Setup Script

# SSH Setup
read -p "Use SSH for Git? [y/N]: " ssh_choice
if [[ "$ssh_choice" =~ ^[Yy]$ ]]; then
  ssh-keygen -t ed25519 -C "$(hostname)" -N "" -f ~/.ssh/id_ed25519
  eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519
  echo "Public key (add to Git account):"
  cat ~/.ssh/id_ed25519.pub
  GIT_CLONE_PREFIX="git@gitlab.com:"
else
  GIT_CLONE_PREFIX="https://gitlab.com/"
fi

# Dotfiles
echo "Configuring Dotfiles"
[ ! -d ~/dotfiles ] && git clone $GIT_CLONE_PREFIX/ezraravinmateus/dotfiles.git ~/dotfiles &&
  cp -r ~/dotfiles/. ~/ && rm -rf ~/dotfiles

# Git Config
echo "Configuring Git"
if ! git config --global user.email &>/dev/null; then
  read -p "Git email: " git_email
  read -p "Git name: " git_name
  git config --global user.email "$git_email"
  git config --global user.name "$git_name"
  git config --global init.defaultBranch main
fi

# System
echo "Enabling Bluetooth"
sudo systemctl enable --now bluetooth

# Quick System Finalization
echo "Updating system..."
sudo pacman -Syu --noconfirm
echo "Cleaning up packages..."
sudo pacman -Sc --noconfirm
read -p "Setup Complete. Reboot now? [y/N]: " reboot_choice
[[ "$reboot_choice" =~ ^[Yy]$ ]] && sudo reboot
