# 0. Table Of Contents

1. [Settings Setup](#SettingsSetup)
2. [Install Apps](#InstallApp)
3. [Install Development Tools](#InstallDevelopmentTool)
4. [Clear Cache](#ClearCache)

# <a name = "SettingsSetup"></a>1. 🔧 Settings Setup

- Settings
    - General
        - About > eRavenous MBA (Change Name)
    - Control Center
        - Automatically Hide & Show The Menu Bar > Always
    - Desktop & Dock
        - Enable > Automatically Hide & Show The Dock
        - Minimize Windows Using > Scale Effect
        - Disable > Show Suggested & Recent Apps in Dock
    - Displays > Advanced > Show Resolutions As List > 1680 x 1050
    - Keyboard > Text Input > Edit
        - Disable > Correct spelling automatically
        - Disable > Add period with double-space
        - Disable > Capitalize words automatically
        - Key Repeat Rate > Fast
        - Delay Until Repeat > Short

## 1.1 Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 1.2 Oh-My-ZSH

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm .zshrc
```

# <a name = "InstallApp"></a>2. 🍥 Install Apps

```bash
brew install --cask kitty google-chrome basictex nikitabobko/tap/aerospace
```

# <a name = "InstallDevelopmentTool"></a>3. 🔧 Install Dev Tools

## 3.1 Package Manager

```bash
brew install node pnpm yarn oven-sh/bun/bun
```

## 3.2 Terminal Tools

```bash
brew install jandedobbeleer/oh-my-posh/oh-my-posh eza zoxide neovim zsh-syntax-highlighting zsh-autosuggestions
```

## 3.3 Neovim Tools

```bash
brew install ripgrep lazygit libgit2 yazi pandoc ueberzugpp imagemagick marp-cli pngpaste
```

## 3.4 Laravel

```bash
brew install php composer artisan docker-compose docker
brew install --cask docker

```

## 3.5 AutoUpdate Homebrew

```bash
brew tap domt4/autoupdate
brew autoupdate start 43200 --cleanup --upgrade --immediate --sudo
```

