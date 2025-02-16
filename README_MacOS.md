# Global Config with Git

```bash
git config --global user.email "ezraravin@proton.me"
git config --global user.name "Ezra Ravin Mateus"
```

# SYSTEM SETTINGS

```bash
# Set Computer Name
sudo scutil --set ComputerName "eRave"
sudo scutil --set HostName "eRave"
sudo scutil --set LocalHostName "eRave"

# Control Center: Always Hide Menu Bar
defaults write -g \_HSUI_AHideMenuBar -int 1

# Desktop & Dock Settings

# Auto-hide Dock
defaults write com.apple.dock autohide -bool true
# Scale effect for minimizing
defaults write com.apple.dock mineffect -string "scale"
# Disable suggested/recent apps
defaults write com.apple.dock show-recents -bool false

# Keyboard Text Input & Mouse Settings

# Disable auto-corrections
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# Key Repeat: Fastest (60ms per repeat)
defaults write -g KeyRepeat -int 1

# Delay Until Repeat: Shortest (15ms)
defaults write -g InitialKeyRepeat -int 15

# Set Mouse Tracking Speed to 0.5
defaults write -g com.apple.mouse.scaling -float 0.75

# Disable Pointer Acceleration
defaults write -g com.apple.mouse.scaling -float -1

# Enable Dark Mode
defaults write -g AppleInterfaceStyle -string "Dark"

# Repeat Rate

# Reset System
killall SystemUIServer Dock Finder
```

## 1.1 Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 1.2 Oh-My-ZSH

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## 2.1 Terminal Tools

```bash
brew install node pnpm yarn oven-sh/bun/bun jandedobbeleer/oh-my-posh/oh-my-posh eza zoxide neovim zsh-syntax-highlighting zsh-autosuggestions fzf tmux marp-cli pngpaste yazi ripgrep ollama htop fastfetch
brew install kitty brave-browser nikitabobko/tap/aerospace spotify whatsapp chatbox

```

## 2.2 Laravel

```bash
# PHP, COMPOSER, LARAVEL
/bin/bash -c "$(curl -fsSL https://php.new/install/mac)"
brew install docker-compose docker
brew install --cask docker
```

## 2.3 AutoUpdate Homebrew

```bash
brew install pinentry-mac
brew tap domt4/autoupdate
brew autoupdate start 43200 --cleanup --upgrade --immediate --sudo
```
