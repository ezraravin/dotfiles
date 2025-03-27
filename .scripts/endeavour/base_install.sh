#!/bin/bash
# Simple System Setup with one-time sudo

# Ask for sudo once and keep it alive in background
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# GIT - SSH Setup (runs as normal user)
read -p "Use SSH for Git? [y/N]: " ssh_choice
if [[ "$ssh_choice" =~ ^[Yy]$ ]]; then
  read -p "Name for SSH key: " key_name
  ssh-keygen -t ed25519 -C "$key_name" -N "" -f ~/.ssh/id_ed25519
  echo "Public key (add to Git account):"
  cat ~/.ssh/id_ed25519.pub
  read -p "Press Enter after adding key to Git account..."
  GIT_CLONE_PREFIX="git@gitlab.com:"
else
  GIT_CLONE_PREFIX="https://gitlab.com/"
fi

# GIT - Dotfiles (runs as normal user)
[ ! -d ~/dotfiles ] && git clone $GIT_CLONE_PREFIX/ezraravinmateus/dotfiles.git ~/dotfiles &&
  cp -r ~/dotfiles/. ~/ && rm -rf ~/dotfiles

# GIT - Git Config (runs as normal user)
if ! git config --global user.email &>/dev/null; then
  git config --global user.email "ezraravin@proton.me"
  git config --global user.name "Rave"
  git config --global init.defaultBranch main
fi

# CONFIG - Enable bluetooth
sudo systemctl enable --now bluetooth

# SETUP - AI
echo "🤖 AI Development Setup"
echo "🦙 Installing Ollama"
curl -fsSL https://ollama.com/install.sh | sh
echo "💬 Installing Chatbox"
yay -S --noconfirm chatbox-bin
echo "📥 Downloading AI Models"
ollama pull deepseek-coder-v2
ollama pull deepseek-v2
ollama pull deepseek-r1
echo "✅ AI tools configured"

# CONFIG - Update system
sudo pacman -Syu --noconfirm
sudo pacman -Sc --noconfirm

read -p "Setup Complete. Reboot now? [y/N]: " reboot_choice
[[ "$reboot_choice" =~ ^[Yy]$ ]] && sudo reboot
