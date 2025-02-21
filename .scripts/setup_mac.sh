#!/bin/bash

# Enable error handling and verbose output
set -e
set -o pipefail
exec > >(tee -i setup.log) 2>&1

##############################################
### 1. System Configuration
##############################################
configure_system() {
    echo "⚙️ Configuring System Settings..."

    # Clear apps and folders from the Dock if they exist
    if defaults read com.apple.dock persistent-apps >/dev/null 2>&1; then
        echo "  ↳ Removing persistent-apps..."
        defaults delete com.apple.dock persistent-apps
    else
        echo "  ↳ persistent-apps does not exist, skipping..."
    fi

    if defaults read com.apple.dock persistent-others >/dev/null 2>&1; then
        echo "  ↳ Removing persistent-others..."
        defaults delete com.apple.dock persistent-others
    else
        echo "  ↳ persistent-others does not exist, skipping..."
    fi

    # Apple Silicon specific setup
    if [[ "$(uname -m)" == "arm64" ]]; then
        echo "  ↳ Installing Rosetta 2..."
        sudo softwareupdate --install-rosetta --agree-to-license
    fi

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
    defaults write -g com.apple.mouse.scaling -float 1.0
    defaults write -g com.apple.mouse.scaling -float -1

    # Apply changes
    killall SystemUIServer Dock Finder
}

##############################################
### 2. Package Management Setup
##############################################
setup_package_management() {
    echo "📦 Setting Up Package Management..."

    # Install Homebrew
    if ! command -v brew &>/dev/null; then
        echo "  ↳ Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # Install MAS (Mac App Store CLI)
    if ! command -v mas &>/dev/null; then
        echo "  ↳ Installing MAS..."
        brew install mas
    fi

    # Configure auto-updates (only if not already running)
    brew install pinentry-mac
    brew tap domt4/autoupdate

    if brew autoupdate status | grep -q "running"; then
        echo "  ↳ brew autoupdate is already running, skipping..."
    else
        echo "  ↳ Starting brew autoupdate..."
        brew autoupdate start 43200 --cleanup --upgrade --immediate --sudo
    fi
}

##############################################
### 3. Xcode Installation (Core)
##############################################
install_xcode() {
    echo "🛠️ Installing Xcode..."

    if [ ! -d "/Applications/Xcode.app" ]; then
        # Ensure App Store authentication
        if ! mas account >/dev/null 2>&1; then
            echo "  ↳ Please sign in to App Store when prompted..."
            open -a "App Store"
            read -n1 -p "Press any key when you've signed in to continue..."
        fi

        # Install Xcode (App Store ID: 497799835)
        echo "  ↳ Starting Xcode installation (this may take 30+ minutes)..."
        mas install 497799835

        # Wait for installation
        while [ ! -d "/Applications/Xcode.app" ]; do
            echo "  ↳ Waiting for Xcode installation to complete..."
            sleep 60
        done

        # Post-install setup
        echo "  ↳ Configuring Xcode..."
        sudo xcode-select --switch /Applications/Xcode.app
        sudo xcodebuild -license accept
        sudo xcodebuild -runFirstLaunch
    else
        echo "  ↳ Xcode already installed at /Applications/Xcode.app"
    fi
}

##############################################
### 4. Development Environment Setup
##############################################
setup_development_environment() {
    echo "👨💻 Setting Up Development Environment..."

    # JavaScript ecosystem
    brew install node pnpm oven-sh/bun/bun

    # Editors and tools
    brew install neovim tmux ripgrep btop

    # PHP/Laravel
    /bin/bash -c "$(curl -fsSL https://php.new/install/mac)"
}

##############################################
### 4. Mobile Development Setup
##############################################
setup_mobile_development() {
    echo "📱 Setting Up Mobile Development..."

    # Flutter installation
    brew install --cask flutter

    # Chrome installation
    brew install --cask google-chrome

    # Android Studio
    brew install --cask android-studio temurin android-commandlinetools
    yes | sdkmanager --licenses
    sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0 emulator"

    # Android licenses
    yes | flutter doctor --android-licenses

    # CocoaPods
    brew install cocoapods

    # Verify setup
    flutter doctor
}

##############################################
### 5. Application Installation
##############################################
install_applications() {
    echo "📦 Installing Applications..."

    # Browsers and communication
    brew install --cask brave-browser signal

    # Development tools
    brew install --cask android-studio kitty

    # Media tools
    brew install --cask obs

    # Utilities
    brew install --cask nikitabobko/tap/aerospace
}

##############################################
### 6. Shell Environment Setup
##############################################
setup_shell_environment() {
    echo "🐚 Configuring Shell Environment..."

    # Oh My Zsh
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Shell tools
    brew install zsh-syntax-highlighting zsh-autosuggestions eza zoxide fzf oh-my-posh

    # Yazi SVG Viewer Support
    brew install librsvg imagemagick chafa

    # PDF Support for Markdown to PDF
    brew install basictex pandoc
}

##############################################
### 8. Git & Dotfiles Configuration
##############################################
configure_git_and_dotfiles() {
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
}

##############################################
### 9. Top Menu Bar Configuration
##############################################

setup_ui_customization() {
    echo "🎨 Configuring UI Customizations..."

    # Install and start SketchyBar
    if ! command -v sketchybar &>/dev/null; then
        echo "  ↳ Installing SketchyBar..."
        brew install FelixKratz/formulae/sketchybar
    else
        echo "  ↳ SketchyBar already installed."
    fi

    # Start SketchyBar as a service
    brew services start sketchybar
}

##############################################
### Main Execution Flow
##############################################
main() {
    # Extend sudo timeout to 1 hour (3600 seconds)
    sudo -v
    while true; do
        sudo -n true
        sleep 300
        kill -0 "$$" || exit
    done 2>/dev/null &

    configure_system
    setup_package_management
    install_xcode
    setup_development_environment
    setup_mobile_development
    install_applications
    setup_shell_environment
    configure_git_and_dotfiles
    setup_ui_customization

    echo "✅ Setup complete! Some changes may require a restart."
    echo "🔍 Review installation log: setup.log"
}

# Start the main process
main
