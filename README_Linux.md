# MAKE KEYGEN

```bash
ssh-keygen -t ed25519 -C "ezraravin.m@gmail.com"
```

# INSTALL HYPRLAND, GOOGLE CHROME, KITTY, KDENLIVE, OBS, ZSH, WL CLIPBOARD

```bash
sudo dnf install -y hyprland google-chrome-stable kitty kdenlive obs-studio zsh wl-clipboard development-tools
```

# CHANGE SHELL TO ZSH

```bash
chsh -s $(which zsh)
```

# INSTALL OH MY ZSH

```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

# INSTALL HOMEBREW

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install gcc
```

# INSTALL SPOTIFY

```bash
flatpak install -y flathub com.spotify.Client
```

# INSTALL JETBRAINS NERD FONT

```bash
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip && sudo unzip JetBrainsMono.zip -d /usr/share/fonts/truetype/ && sudo rm -rf JetBrainsMono.zip
```

# INSTALL EZA, YAZI, MARP, LAZYGIT, ZOXIDE, ZSH-SYNTAX-HIGHLIGHTING, ZSH-AUTOSUGGESTIONS, NEOVIM, TMUX, BUN, OH MY POSH, PHP, COMPOSER

```bash
brew install eza yazi marp-cli lazygit zoxide zsh-syntax-highlighting zsh-autosuggestions neovim tmux oven-sh/bun/bun jandedobbeleer/oh-my-posh/oh-my-posh php composer
```

# REMOVE BLOATWARE

```bash
sudo dnf remove -y rhythmbox ptyxis mediawriter totem yelp firefox libreoffice-impress libreoffice-calc libreoffice-writer snapshot snapshot gnome-contacts gnome-weather gnome-clocks gnome-maps gnome-calculatr gnome-boxes gnome-characters gnome-tour gnome-text-editor gnome-software gnome-abrt gnome-calculator
```

# UPDATE & UPGRADE

```bash
sudo dnf update --refresh && sudo dnf upgrade --refresh
sudo dnf install kernel-devel kernel-headers gcc make dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf makecache
sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda
sudo reboot
```
