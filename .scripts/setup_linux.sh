#!/bin/bash

# MAKE KEYGEN
ssh-keygen -t ed25519 -C "Rave's PC"

# Install Hyprland
sudo pacman -S --noconfirm hyprland hyprpaper zsh neovim tmux eza waybar obs-studio cava fastfetch yazi lazygit zoxide zsh-syntax-highlighting zsh-autosuggestions yarn fzf eza yazi lazygit thefuck wl-clipboard pavucontrol vlc blueman network-manager-applet networkmanager bat ffmpeg wofi btop

# MARP CLI
yay -S --noconfirm marp-cli spotify spotify-adblock whatsapp-for-linux arduino-ide xampp android-studio android-sdk android-sdk-build-tools android-sdk-cmdline-tools-latest chatbox-bin

# FLUTTER ANDROID SDK
sudo chown -R $USER:$USER /opt/android-sdk

# INSTALL HOMEBREW
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# INSTALL JETBRAINS NERD FONT
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip && sudo unzip JetBrainsMono.zip -d /usr/share/fonts/truetype/ && sudo rm -rf JetBrainsMono.zip
