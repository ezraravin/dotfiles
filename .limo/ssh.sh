read -p "Use SSH for Git? [y/N]: " ssh_choice
if [[ "$ssh_choice" =~ ^[Yy]$ ]]; then
  read -p "Name for SSH key: " key_name
  ssh-keygen -t ed25519 -C "$key_name" -N "" -f ~/.ssh/id_ed25519
  echo "📋 Public key (add to Git account):"
  cat ~/.ssh/id_ed25519.pub
  echo "🔗 Paste this in your Git account settings!"
  read -p "Press Enter after adding key to Git account..."
  GIT_CLONE_PREFIX="git@github.com:"
else
  GIT_CLONE_PREFIX="https://github.com/"
fi