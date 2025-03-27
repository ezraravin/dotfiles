#!/bin/bash
# Ask if user wants to use SSH
read -p "Configure Git to use SSH? [y/N]: " use_ssh
if [[ "$use_ssh" =~ ^[Yy]$ ]]; then
  # Get PC name for key comment
  pc_name=$(hostname)
  read -p "Enter name for this PC [$pc_name]: " input_name
  pc_name=${input_name:-$pc_name}

  # Generate SSH key if it doesn't exist
  ssh_key="$HOME/.ssh/id_ed25519"
  if [ ! -f "$ssh_key" ]; then
    ssh-keygen -t ed25519 -C "$pc_name $(date +%Y-%m-%d)" -N "" -f "$ssh_key"
    eval "$(ssh-agent -s)" >/dev/null
    ssh-add "$ssh_key"
  fi

  # Show public key and instructions
  echo -e "\nPublic key (add to your Git account):"
  cat "$ssh_key.pub"
  echo -e "\n1. Copy the key above"
  echo "2. Add it to your Git provider's SSH settings"
  echo "3. Test with: ssh -T git@gitlab.com"

  # Set Git to use SSH
  GIT_CLONE_PREFIX="git@gitlab.com:"
else
  # Set Git to use HTTPS
  GIT_CLONE_PREFIX="https://gitlab.com/"
fi

echo -e "\nGit will clone using: $GIT_CLONE_PREFIX"
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
