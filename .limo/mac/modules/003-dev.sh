##############################################
### Development Environment
##############################################

# Core tools
brew install node pnpm oven-sh/bun/bun python visidata neovim tmux ripgrep btop yarn mas cocoapods

# PHP/Laravel
/bin/bash -c "$(curl -fsSL https://php.new/install/mac)"

##############################################
### Applications
##############################################
brew install --cask kitty obs kdenlive nikitabobko/tap/aerospace font-jetbrains-mono-nerd-font spotify google-chrome flutter whatsapp cloudflare-warp android-studio figma google-drive notion numi chatbox gather zen

# XCODE
mas install 497799835
sudo xcode-select --switch /Applications/Xcode.app
sudo xcodebuild -license accept
sudo xcodebuild -runFirstLaunch

# FLUTTER
brew tap leoafarias/fvm
brew install fvm
xcodebuild -downloadPlatform iOS

##############################################
### Shell Environment
##############################################

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Shell tools
brew install zsh-syntax-highlighting zsh-autosuggestions eza zoxide fzf oh-my-posh yazi thefuck cava cmatrix pipes-sh librsvg imagemagick chafa lazygit lazydocker fastfetch

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