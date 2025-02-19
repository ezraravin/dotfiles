#!/bin/bash

# Extend sudo timeout to 1 hour (3600 seconds)
sudo -v
while true; do
    sudo -n true
    sleep 300
    kill -0 "$$" || exit
done 2>/dev/null &

##############################################
### 1. System Settings
##############################################
echo "Configuring System Settings..."

# Install Rosetta for Apple Silicon
if [[ "$(uname -m)" == "arm64" ]]; then
    echo "Installing Rosetta 2..."
    sudo softwareupdate --install-rosetta --agree-to-license
fi

# Computer Name
sudo scutil --set ComputerName "eRave"
sudo scutil --set HostName "eRave"
sudo scutil --set LocalHostName "eRave"

# Enable Dark Mode
echo "Enabling Dark Mode..."
defaults write -g AppleInterfaceStyle "Dark"

# Screen Saver Settings
echo "Configuring Screen Saver and Display Sleep..."
defaults -currentHost write com.apple.screensaver idleTime 0    # Disable screen saver
defaults write com.apple.screensaver askForPassword -bool true  # Require password on wake
defaults write com.apple.screensaver askForPasswordDelay -int 0 # No delay for password prompt

# Display Sleep Settings
sudo pmset -b displaysleep 60 # 60 minutes on battery
sudo pmset -c displaysleep 60 # 60 minutes on power adapter

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

# Control Center Settings
defaults write com.apple.controlcenter BatteryShowPercentage -bool TRUE

# Apply changes
killall SystemUIServer Dock Finder

##############################################
### 2. Package Management
##############################################
echo "Setting up Package Management..."

# Install Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
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
    echo "Installing Oh-My-Zsh..."
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

##############################################
### 5. Flutter Stack
##############################################
echo "Setting up Flutter Stack..."

# Install Chrome for Flutter web development
echo "Installing Google Chrome..."
brew install --cask google-chrome

# Install MAS (Mac App Store CLI)
echo "Installing MAS..."
brew install mas

# Install Xcode
if ! /usr/bin/xcode-select -p &>/dev/null; then
    echo "Installing Xcode (this may take 30+ minutes)..."
    mas install 497799835

    # Wait for Xcode installation
    while [ ! -d "/Applications/Xcode.app" ]; do
        echo "Waiting for Xcode installation to complete..."
        sleep 60
    done

    # Accept Xcode license
    sudo xcodebuild -license accept
    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
    sudo xcodebuild -runFirstLaunch
fi

# Install Flutter
echo "Installing Flutter..."
brew install --cask flutter

# Install Android Studio
echo "Installing Android Studio..."
brew install --cask android-studio

# Accept Android Licenses
yes | flutter doctor --android-licenses

# Install CocoaPods
echo "Installing Ruby & CocoaPods..."
brew install ruby cocoapods

# Verify Flutter Installation
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

git config --global user.email "ezraravin@proton.me"
git config --global user.name "MacBook Air M1"
git config --global init.defaultBranch main
git config --global credential.helper store

echo "Setup complete! Some changes may require a restart."
