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
### 0. Prerequisites: Xcode Command Line Tools
##############################################
echo "Checking for Xcode Command Line Tools..."

if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
    softwareupdate -i "$PROD" --verbose
    rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
else
    echo "Xcode Command Line Tools are already installed."
fi

##############################################
### 1. Git Configuration
##############################################
echo "Configuring Git..."
git config --global user.email "ezraravin@proton.me"
git config --global user.name "Ezra Ravin Mateus"

##############################################
### 2. System Settings
##############################################
echo "Configuring System Settings..."

# Computer Name
sudo scutil --set ComputerName "eRave"
sudo scutil --set HostName "eRave"
sudo scutil --set LocalHostName "eRave"

# Menu Bar and Dock
defaults write -g _HSUI_AHideMenuBar -int 1
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
### 3. Package Management
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
### 4. Shell Environment
##############################################
echo "Configuring Shell Environment..."

# Oh-My-Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Shell Tools
brew install oh-my-posh zsh-syntax-highlighting zsh-autosuggestions eza zoxide fzf

##############################################
### 5. Development Tools
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

echo "Setup complete! Some changes may require a restart."
