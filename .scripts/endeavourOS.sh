#!/bin/bash
# EndeavourOS Setup Script

# Ask for sudo once and keep it alive
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Git SSH Setup
echo "🔐 Git SSH Setup"
read -p "Use SSH for Git? [y/N]: " ssh_choice
if [[ "$ssh_choice" =~ ^[Yy]$ ]]; then
  read -p "Name for SSH key: " key_name
  ssh-keygen -t ed25519 -C "$key_name" -N "" -f ~/.ssh/id_ed25519
  echo "📋 Public key (add to Git account):"
  cat ~/.ssh/id_ed25519.pub
  echo "🔗 Paste this in your Git account settings!"
  read -p "Press Enter after adding key to Git account..."
  GIT_CLONE_PREFIX="git@gitlab.com:"
else
  GIT_CLONE_PREFIX="https://gitlab.com/"
fi

# Dotfiles
[ ! -d ~/dotfiles ] && git clone $GIT_CLONE_PREFIX/ezraravinmateus/dotfiles.git ~/dotfiles &&
  cp -r ~/dotfiles/. ~/ && rm -rf ~/dotfiles

# Git Config
if ! git config --global user.email &>/dev/null; then
  git config --global user.email "ezraravin@proton.me"
  git config --global user.name "Rave"
  git config --global init.defaultBranch main
fi

# Bluetooth & Wifi
echo "ᛒ Enabling Bluetooth"
sudo systemctl enable --now bluetooth

# Display Manager
echo "🖥️ SDDM Setup"
sudo pacman -S --noconfirm sddm
sudo systemctl enable sddm
echo "✅ SDDM installed"

# GPU Drivers
echo "🔍 GPU Detection"
if lspci | grep -i "VGA.*NVIDIA"; then
  echo "🟢 NVIDIA detected"
  sudo pacman -S --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
  sudo pacman -S --noconfirm cuda cudnn
  sudo mkinitcpio -P
elif lspci | grep -i "VGA.*AMD"; then
  echo "🔴 AMD detected"
  sudo pacman -S --noconfirm mesa vulkan-radeon lib32-vulkan-radeon
elif lspci | grep -i "VGA.*Intel"; then
  echo "🔵 Intel detected"
  sudo pacman -S --noconfirm mesa vulkan-intel lib32-vulkan-intel
fi
echo "✅ GPU setup complete"

# Core Tools
echo "🐧 Core Setup"
sudo pacman -S --noconfirm eza bat ripgrep fd nautilus btop cava fastfetch blueman kitty xorg-xwayland
echo "✅ Core tools installed"

# Window Managers
echo "🌌 Hyprland Setup"
sudo pacman -S --noconfirm hyprland hyprpaper hyprlock waybar wofi grim slurp wl-clipboard
echo "✅ Hyprland installed"

# Dev Environment
echo "👨💻 Dev Setup"
sudo pacman -S --noconfirm nodejs npm python yarn pnpm lazygit docker docker-compose visidata
yay -S --noconfirm lazydocker marp-cli
/bin/bash -c "$(curl -fsSL https://php.new/install/linux)"
curl -fsSL https://bun.sh/install | bash
echo "✅ Dev tools installed"

# Shell
echo "🐚 Shell Setup"
sudo pacman -S --noconfirm zsh zsh-syntax-highlighting zsh-autosuggestions zsh-completions tmux neovim zoxide fzf thefuck imagemagick librsvg chafa ffmpeg ttf-jetbrains-mono-nerd yazi
curl -s https://ohmyposh.dev/install.sh | bash -s
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Tmux Plugin Manager
echo "🖥️ Setting up Tmux Plugin Manager"
[ ! -d ~/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Install tmux plugins
if [ -f ~/.tmux.conf ]; then
  echo "🔌 Installing Tmux plugins"
  tmux start-server
  tmux new-session -d
  ~/.tmux/plugins/tpm/scripts/install_plugins.sh
  tmux kill-server
  echo "✅ Tmux plugins installed"
fi

sudo chsh -s $(which zsh) $USER
echo "✅ Shell configured"

# iI Tools
echo "🤖 AI Setup"
echo "💬 Installing Chatbox"
yay -S --noconfirm chatbox-bin
echo "✅ AI setup complete"

# Applications
echo "🖥️ App Setup"
echo "🌐 Browsers"
curl -fsS https://dl.brave.com/install.sh | sh
yay -S --noconfirm whatsapp-for-linux

echo "🎵 Music"
yay -S --noconfirm spotify spotify-adblock

echo "🎬 Media"
sudo pacman -S --noconfirm vlc obs-studio

echo "💾 Ventoy"
yay -S --noconfirm ventoy-bin

echo "✅ Apps installed"

# Arduino
echo "⚡ Arduino Setup"
yay -S --noconfirm arduino-ide
sudo usermod -a -G uucp,tty $USER
sudo curl -o /etc/udev/rules.d/60-arduino.rules https://raw.githubusercontent.com/arduino/ArduinoCore-avr/master/60-arduino-avr-core.rules
sudo udevadm control --reload
echo "✅ Arduino ready"

# Final update
sudo pacman -Syu --noconfirm
sudo pacman -Sc --noconfirm
curl -fsSL "https://gitlab.com/ezraravinmateus/dotfiles/-/raw/HEAD/.zshrc" >~/.zshrc

# Reboot prompt
echo "🎉 Setup complete! Rebooting in 5 seconds..."
sleep 5
sudo reboot
