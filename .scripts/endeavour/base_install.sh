#!/bin/bash
# Simple System Setup

# SSH Setup
read -p "Use SSH for Git? [y/N]: " ssh_choice
if [[ "$ssh_choice" =~ ^[Yy]$ ]]; then
  read -p "Name for SSH key: " key_name
  ssh-keygen -t ed25519 -C "$key_name" -N "" -f ~/.ssh/id_ed25519
  eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519
  echo -e "\nPublic key (add to Git account):"
  cat ~/.ssh/id_ed25519.pub
  read -p "Press Enter after adding key to Git account..."
  GIT_CLONE_PREFIX="git@gitlab.com:"
else
  GIT_CLONE_PREFIX="https://gitlab.com/"
fi

# Dotfiles
[ ! -d ~/dotfiles ] && git clone $GIT_CLONE_PREFIX/ezraravinmateus/dotfiles.git ~/dotfiles &&
  cp -r ~/dotfiles/. ~/ && rm -rf ~/dotfiles

# Git Config
if ! git config --global user.email &>/dev/null; then
  read -p "Git email: " git_email
  read -p "Git name: " git_name
  git config --global user.email "$git_email"
  git config --global user.name "$git_name"
  git config --global init.defaultBranch main
fi

# System
sudo systemctl enable --now bluetooth
sudo pacman -Syu --noconfirm
sudo pacman -Sc --noconfirm

read -p "Setup Complete. Reboot now? [y/N]: " reboot_choice
[[ "$reboot_choice" =~ ^[Yy]$ ]] && sudo reboot
