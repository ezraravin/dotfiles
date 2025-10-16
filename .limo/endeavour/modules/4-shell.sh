# Shell
echo "🐚 Shell Setup"
sudo pacman -S --noconfirm zsh zsh-syntax-highlighting zsh-autosuggestions zsh-completions tmux neovim zoxide fzf thefuck imagemagick librsvg chafa ffmpeg ttf-jetbrains-mono-nerd ttf-jetbrains-mono yazi mysql-workbench
curl -s https://ohmyposh.dev/install.sh | bash -s
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo " Change Shell"
sudo chsh -s $(which zsh) $USER
echo "✅ Shell configured"
