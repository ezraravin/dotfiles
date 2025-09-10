#!/bin/bash

# Extend sudo timeout for the entire script
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" 2>/dev/null || exit
done &

# Git protocol selection
read -rp "Use SSH for Git? [y/N] " git_response
if [[ "$git_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  GIT_URL="git@gitlab.com:"
else
  GIT_URL="https://gitlab.com/"
fi

##############################################
### System Configuration
##############################################

# Dock settings
defaults write com.apple.dock persistent-apps ""
defaults write com.apple.dock persistent-others ""
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.controlcenter BatteryShowPercentage -bool TRUE

# System identity
sudo scutil --set ComputerName "eRave"
sudo scutil --set HostName "eRave"
sudo scutil --set LocalHostName "eRave"

# Security and power
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay -int 0
sudo pmset -b displaysleep 60
sudo pmset -c displaysleep 60

# Input settings
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15
defaults write -g com.apple.mouse.scaling -float 1.05
killall SystemUIServer Dock Finder

##############################################
### Package Management
##############################################

# Install Homebrew if needed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Configure Homebrew
if [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Brew autoupdate
brew install pinentry-mac
brew tap domt4/autoupdate
if ! brew autoupdate status | grep -q "running"; then
  brew autoupdate start 43200 --cleanup --upgrade --immediate --sudo
fi

##############################################
### Display Configuration
##############################################

brew install jakehilborn/jakehilborn/displayplacer
displayplacer "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1440x900 hz:60 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0"

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

##############################################
### Git & Dotfiles
##############################################

git config --global user.email "ezraravin@proton.me"
git config --global user.name "MacBook Air M1"
git config --global init.defaultBranch main

if [ ! -d "$HOME/dotfiles" ]; then
  git clone "${GIT_URL}ezraravinmateus/dotfiles.git" "$HOME/dotfiles"
  rsync -a "$HOME/dotfiles/." "$HOME/"
  rm -rf "$HOME/dotfiles"
fi

echo "✅ Setup complete"
