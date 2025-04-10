#!/bin/bash

##############################################
### System Configuration
##############################################
echo "⚙️ Configuring System Settings..."

# Clear apps and folders from the Dock
defaults write com.apple.dock persistent-apps ""
defaults write com.apple.dock persistent-others ""

# System identity
sudo scutil --set ComputerName "eRave"
sudo scutil --set HostName "eRave"
sudo scutil --set LocalHostName "eRave"

# UI Preferences
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.controlcenter BatteryShowPercentage -bool TRUE

# Security settings
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Power management
sudo pmset -b displaysleep 60
sudo pmset -c displaysleep 60

# Keyboard and Input
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15

# Mouse Settings
defaults write -g com.apple.mouse.scaling -float 1.05
defaults write -g com.apple.mouse.scaling -float -1

# Apply changes
killall SystemUIServer Dock Finder

##############################################
### Package Management Setup
##############################################
echo "📦 Setting Up Package Management..."

# Install Homebrew if not exists
if ! command -v brew >/dev/null 2>&1; then
  echo "  ↳ Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# Configure auto-updates
brew install pinentry-mac
brew tap domt4/autoupdate

if ! brew autoupdate status | grep -q "running"; then
  echo "  ↳ Starting brew autoupdate..."
  brew autoupdate start 43200 --cleanup --upgrade --immediate --sudo
else
  echo "  ↳ brew autoupdate is already running, skipping..."
fi

##############################################
### Display Configuration
##############################################
echo "🖥️ Configuring Display Settings..."

# Install displayplacer if not exists
if ! command -v displayplacer >/dev/null 2>&1; then
  echo "  ↳ Installing displayplacer..."
  brew install jakehilborn/jakehilborn/displayplacer
fi

# Set display configuration
echo "  ↳ Applying display configuration..."
displayplacer "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1440x900 hz:60 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0"

# Verify configuration
if displayplacer list | grep -q "1680x1050"; then
  echo "  ↳ Display configuration verified successfully"
else
  echo "  ↳ Warning: Display configuration might not have applied correctly"
  echo "  ↳ Check available resolutions with: displayplacer list"
fi

##############################################
### Development Environment Setup
##############################################
echo "👨💻 Setting Up Development Environment..."

# JavaScript Ecosystem
brew install node pnpm oven-sh/bun/bun

# Python Environment
brew install python visidata

# Editors and tools
brew install neovim tmux ripgrep btop

# PHP/Laravel
/bin/bash -c "$(curl -fsSL https://php.new/install/mac)"

##############################################
### Application Installation
##############################################
echo "📦 Installing Applications..."

# Browsers
brew install --cask brave-browser

# Development tools
brew install --cask kitty

# Media tools
brew install --cask obs kdenlive

# Utilities
brew install --cask nikitabobko/tap/aerospace

# Fonts
brew install --cask font-jetbrains-mono-nerd-font

##############################################
### Shell Environment Setup
##############################################
echo "🐚 Configuring Shell Environment..."

# Oh My Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Shell tools
brew install zsh-syntax-highlighting zsh-autosuggestions eza zoxide fzf oh-my-posh yazi thefuck cava cmatrix pipes-sh

# File SVG Viewer & FFMPEG Support
brew install librsvg imagemagick chafa ffmpeg

# PDF Support for Markdown to PDF
brew install basictex pandoc

# WebP
brew install webp

# UNRAR
brew install carlocab/personal/unrar

##############################################
### Git & Dotfiles Configuration
##############################################
echo "🔧 Configuring Git & Dotfiles..."

git config --global user.email "ezraravin@proton.me"
git config --global user.name "MacBook Air M1"
git config --global init.defaultBranch main

# Dotfiles setup
if [[ ! -d "$HOME/dotfiles" ]]; then
  git clone git@gitlab.com:ezraravinmateus/dotfiles.git "$HOME/dotfiles"
  rsync -a "$HOME/dotfiles/." "$HOME/"
  rm -rf "$HOME/dotfiles"
fi

echo "✅ Setup complete! Some changes may require a restart."