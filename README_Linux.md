# MAKE KEYGEN

```bash
ssh-keygen -t ed25519 -C "ezraravin.m@gmail.com"
```

# INSTALL HOMEBREW
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

# INSTALL HYPRLAND, GOOGLE CHROME, KITTY, KDENLIVE, OBS, ZSH, WL CLIPBOARD

```bash
sudo dnf install -y hyprland google-chrome-stable kitty kdenlive obs-studio zsh wl-clipboard
```

# CHANGE SHELL TO ZSH

```bash
chsh -s $(which zsh)
```

# INSTALL SPOTIFY

```bash
flatpak install -y flathub com.spotify.Client
```

# INSTALL JETBRAINS NERD FONT

```bash
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip && sudo unzip JetBrainsMono.zip -d /usr/share/fonts/truetype/ && sudo rm -rf JetBrainsMono.zip
```

# INSTALL YAZI, MARP, LAZYGIT, ZOXIDE, ZSH-SYNTAX-HIGHLIGHTING, ZSH-AUTOSUGGESTIONS, NEOVIM, TMUX, BUN, OH MY POSH

```bash
brew install yazi marp-cli lazygit zoxide zsh-syntax-highlighting zsh-autosuggestions neovim tmux oven-sh/bun/bun jandedobbeleer/oh-my-posh/oh-my-posh
```

# NODEJS

sudo dnf install node npm

# REMOVE BLOATWARE

```bash
sudo dnf remove -y ptyxis mediawriter totem yelp firefox libreoffice-impress libreoffice-calc libreoffice-writer snapshot snapshot gnome-contacts gnome-weather gnome-clocks gnome-maps gnome-calculatr gnome-boxes gnome-characters gnome-tour gnome-text-editor gnome-software gnome-abrt
```

# UPDATE & UPGRADE

```bash
sudo dnf update && sudo dnf upgrade
```

# INSTALL OH MY ZSH

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
