# Tmux Plugin Manager
echo "🖥️ Setting up Tmux Plugin Manager"
[ ! -d ~/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Install tmux plugins
if [ -f ~/.tmux.conf ]; then
  echo "🔌 Installing Tmux plugins"
  tmux start-server
  tmux new-session -d
  ~/.tmux/plugins/tpm/scripts/install_plugins.sh
  tmux kill-server
  echo "✅ Tmux plugins installed"
fi
