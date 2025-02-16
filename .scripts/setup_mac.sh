#!/bin/bash

# Extend sudo timeout to 1 hour (3600 seconds)
sudo -v
while true; do
    # Refresh sudo privileges every 5 minutes (300 seconds)
    sudo -n true
    sleep 300
    kill -0 "$$" || exit
done 2>/dev/null &

##############################################
### 1. System Settings
##############################################
echo "Configuring System Settings..."

# Computer Name
sudo scutil --set ComputerName "eRave"
sudo scutil --set HostName "eRave"
sudo scutil --set LocalHostName "eRave"

# Menu Bar and Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock show-recents -bool false

# Keyboard and Input
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15

# Mouse Settings
defaults write -g com.apple.mouse.scaling -float 0.75
defaults write -g com.apple.mouse.scaling -float -1

# Appearance
defaults write -g AppleInterfaceStyle -string "Dark"
defaults write com.apple.controlcenter BatteryShowPercentage -bool TRUE

# Apply changes
killall SystemUIServer Dock Finder

##############################################
### 2. Package Management
##############################################
echo "Setting up Package Management..."

# Install Homebrew
if ! command_exists brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Setup AutoUpdate
brew install pinentry-mac
brew tap domt4/autoupdate
brew autoupdate start 43200 --cleanup --upgrade --immediate --sudo

##############################################
### 3. Shell Environment
##############################################
echo "Configuring Shell Environment..."

# Oh-My-Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Shell Tools
brew install oh-my-posh zsh-syntax-highlighting zsh-autosuggestions eza zoxide fzf

##############################################
### 4. Development Tools
##############################################
echo "Installing Development Tools..."

# JavaScript Ecosystem
brew install node pnpm yarn oven-sh/bun/bun

# Editors and CLI
brew install neovim tmux ripgrep htop

# Laravel Stack
/bin/bash -c "$(curl -fsSL https://php.new/install/mac)"
brew install docker-compose docker
brew install --cask docker

##############################################
### 5. Flutter Stack
##############################################
echo "Setting up Flutter Stack..."

# Install Flutter
echo "Installing Flutter..."
brew install --cask flutter

# Add Flutter to PATH
echo "Adding Flutter to PATH..."
echo 'export PATH="$PATH:`flutter sdk path`/bin"' >>~/.zshrc
source ~/.zshrc

# Install Android Studio (required for Flutter Android development)
echo "Installing Android Studio..."
brew install --cask android-studio

# Accept Android Licenses (required for Flutter)
echo "Accepting Android licenses..."
flutter doctor --android-licenses

# Install CocoaPods (required for Flutter iOS development)
echo "Installing CocoaPods..."
sudo gem install cocoapods

# Verify Flutter Installation
echo "Verifying Flutter installation..."
flutter doctor

##############################################
### 6. Applications
##############################################
echo "Installing Applications..."

# Browsers and Communication
brew install --cask brave-browser spotify whatsapp

# Utilities
brew install --cask kitty chatbox

# Window Management
brew install --cask nikitabobko/tap/aerospace

##############################################
### 7. Final Setup
##############################################
echo "Finalizing Setup..."

# Install remaining tools
brew install marp-cli pngpaste yazi ollama fastfetch

##############################################
### 8. Git Configuration
##############################################
echo "Configuring Git..."

# Set Git global configuration
git config --global user.email "ezraravin@proton.me"
git config --global user.name "Ezra (MacBook Air M1)"

# Optional: Set default branch name to 'main'
git config --global init.defaultBranch main

# Optional: Enable credential helper to store credentials
git config --global credential.helper store

echo "Git configuration complete."

echo "Setup complete! Some changes may require a restart."
