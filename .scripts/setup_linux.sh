#!/bin/bash

# MAKE KEYGEN
ssh-keygen -t ed25519 -C "Rave's PC"

#!/bin/bash

# Enable error handling and verbose output
set -e
set -o pipefail
exec > >(tee -i setup.log) 2>&1

##############################################
### Cleanup Function
##############################################
cleanup() {
  exit_status=$?
  if [ $exit_status -eq 0 ]; then
    echo "✅ Installation successful. Setup.log has been deleted."
  else
    echo "❌ Installation failed. Error details from setup.log:"
    cat setup.log
  fi
  rm -f setup.log
}

trap cleanup EXIT

##############################################
### Helper Functions
##############################################

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install a package if it doesn't exist
install_if_missing() {
  local package=$1
  local install_command=$2

  if ! command_exists "$package"; then
    echo "  ↳ Installing $package..."
    eval "$install_command"
  else
    echo "  ↳ $package already installed."
  fi
}

##############################################
### System Configuration
##############################################
configure_system() {
  echo "⚙️ Configuring System Settings..."

  # Enable Bluetooth
  echo "  ↳ Enabling Bluetooth..."
  sudo systemctl start bluetooth
  sudo systemctl enable bluetooth
}

# CONFIG GIT
git config --global user.email "ezraravin@proton.me" && git config --global user.name "Rave's Endeavour"

# INSTALL YAY
sudo pacman -S base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay --version
yay -Syu
cd ..
rm -rf yay

# CLONE DOTFILES
mkdir .config
git clone git@gitlab.com:ezraravinmateus/dotfiles
cd dotfiles
mv .config/* ~/.config && sudo rm -rf .config
mv ./* ~/ && mv ./.* ~/ && cd ../ && rm -rf dotfiles

# INSTALL COMPOSER, PHP, LARAVEL
/bin/bash -c "$(curl -fsSL https://php.new/install/linux)"

# INSTALL BRAVE
curl -fsS https://dl.brave.com/install.sh | sh

# INSTALL OLLAMA
curl -fsSL https://ollama.com/install.sh | sh

# Install NVIDIA
sudo pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings

# Start Bluetooth Session & Enable Bluetooth By Default
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

# Install Hyprland
sudo pacman -S --noconfirm hyprland hyprpaper zsh neovim tmux eza waybar obs-studio cava fastfetch yazi lazygit zoxide zsh-syntax-highlighting zsh-autosuggestions yarn fzf eza yazi lazygit thefuck wl-clipboard pavucontrol vlc blueman network-manager-applet networkmanager bat ffmpeg wofi

# MARP CLI
yay -S --noconfirm marp-cli spotify spotify-adblock whatsapp-for-linux arduino-ide xampp android-studio android-sdk android-sdk-build-tools android-sdk-cmdline-tools-latest chatbox-bin

# FLUTTER
yay -S flutter
sudo pacman -S jdk8-openjdk jdk17-openjdk
sudo archlinux-java set java-17-openjdk
sudo chown -R $USER:$USER /opt/android-sdk

# ZOXIDE
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# INSTALL BUN
curl -fsSL https://bun.sh/install | bash

# INSTALL OH MY POSH
curl -s https://ohmyposh.dev/install.sh | bash -s

# INSTALL TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# INSTALL OH MY ZSH
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# CHANGE SHELL TO ZSH
chsh -s $(which zsh)

# INSTALL HOMEBREW
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# INSTALL JETBRAINS NERD FONT
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip && sudo unzip JetBrainsMono.zip -d /usr/share/fonts/truetype/ && sudo rm -rf JetBrainsMono.zip
