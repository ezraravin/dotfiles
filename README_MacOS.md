# 0. Table Of Contents

1. [Settings Setup](#SettingsSetup)
2. [Install Apps](#InstallApp)
3. [Install Development Tools](#InstallDevelopmentTool)
4. [Clear Cache](#ClearCache)

# Global Config with Git

```bash
git config --global user.email "ezraravin.m@gmail.com"
git config --global user.name "Ezra Ravin Mateus"
```

# Set Computer Name

```bash
sudo scutil --set ComputerName "eRave"
sudo scutil --set HostName "eRave"
sudo scutil --set LocalHostName "eRave"
```

# Control Center: Always Hide Menu Bar

```bash
defaults write -g \_HSUI_AHideMenuBar -int 1
```

# Desktop & Dock Settings

```bash
# Auto-hide Dock
defaults write com.apple.dock autohide -bool true
# Scale effect for minimizing
defaults write com.apple.dock mineffect -string "scale"
# Disable suggested/recent apps
defaults write com.apple.dock show-recents -bool false
```

# Keyboard Text Input Settings

```bash
# Disable auto-corrections
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false
```

# Enable Dark Mode

```bash
defaults write -g AppleInterfaceStyle -string "Dark"
```

# Repeat Rate

```bash
# Key Repeat: Fastest (60ms per repeat)
defaults write -g KeyRepeat -int 1

# Delay Until Repeat: Shortest (15ms)
defaults write -g InitialKeyRepeat -int 15
```

# Reset System

```bash
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

## Apps

```bash
brew install --cask kitty brave-browser nikitabobko/tap/aerospace spotify whatsapp
```

# <a name = "InstallDevelopmentTool"></a>3. 🔧 Install Dev Tools

## 2.1 Terminal Tools

```bash
brew install node pnpm yarn oven-sh/bun/bun jandedobbeleer/oh-my-posh/oh-my-posh eza zoxide neovim zsh-syntax-highlighting zsh-autosuggestions fzf tmux marp-cli pngpaste yazi ripgrep
```

## 2.2 Laravel

```bash
brew install php composer artisan docker-compose docker
brew install --cask docker
```

## 2.3 AutoUpdate Homebrew

```bash
brew tap domt4/autoupdate
brew autoupdate start 43200 --cleanup --upgrade --immediate --sudo
```
