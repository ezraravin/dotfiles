#!/bin/bash
# Ubuntu 24.04 Setup Script

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

# Update system first
sudo apt update && sudo apt upgrade -y

# Core Tools
echo "🐧 Core Setup"
sudo apt install -y git exa bat ripgrep fd-find nautilus btop cava fastfetch blueman kitty xwayland
sudo snap install wlogout curl
echo "✅ Core tools installed"

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

# Display Manager (Ubuntu uses GDM by default)
echo "🖥️ Display Manager Setup"
sudo apt install -y gdm3
sudo systemctl enable gdm3
echo "✅ GDM3 installed"

# GPU Drivers
echo "🔍 GPU Detection"
if lspci | grep -i "VGA.*NVIDIA"; then
  echo "🟢 NVIDIA detected"
  sudo apt install -y nvidia-driver-535 nvidia-utils libnvidia-extra-535
  sudo apt install -y nvidia-cuda-toolkit
elif lspci | grep -i "VGA.*AMD"; then
  echo "🔴 AMD detected"
  sudo apt install -y mesa-vulkan-drivers libvulkan1 vulkan-utils
elif lspci | grep -i "VGA.*Intel"; then
  echo "🔵 Intel detected"
  sudo apt install -y mesa-vulkan-drivers libvulkan1 vulkan-utils
fi
echo "✅ GPU setup complete"

# Window Managers
echo "🌌 Hyprland Setup"
sudo apt install -y hyprland hyprpaper hyprlock waybar wofi grim slurp wl-clipboard
echo "✅ Hyprland installed"

# Dev Environment
echo "👨💻 Dev Setup"
sudo apt install -y nodejs npm python3 python3-pip yarnpkg docker.io docker-compose visidata
sudo snap install lazydocker
sudo npm install -g pnpm marp-cli
/bin/bash -c "$(curl -fsSL https://php.new/install/linux)"
curl -fsSL https://bun.sh/install | bash
echo "✅ Dev tools installed"

# Shell
echo "🐚 Shell Setup"
sudo apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions zsh-completions tmux neovim zoxide fzf thefuck imagemagick librsvg-dev ffmpeg fonts-jetbrains-mono
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

# AI Tools
echo "🤖 AI Setup"
echo "💬 Installing Chatbox"
sudo snap install chatbox
echo "✅ AI setup complete"

# Applications
echo "🖥️ App Setup"
echo "🌐 Browsers"
sudo apt install -y brave-browser
sudo snap install whatsapp-for-linux

echo "🎵 Music"
sudo snap install spotify
sudo apt install -y spotify-adblock

echo "🎬 Media"
sudo apt install -y vlc obs-studio

echo "💾 Ventoy"
sudo apt-add-repository -y ppa:ventoy/ventoy
sudo apt update
sudo apt install -y ventoy

echo "✅ Apps installed"

# Arduino
echo "⚡ Arduino Setup"
sudo apt install -y arduino
sudo usermod -a -G dialout,tty $USER
sudo curl -o /etc/udev/rules.d/60-arduino.rules https://raw.githubusercontent.com/arduino/ArduinoCore-avr/master/60-arduino-avr-core.rules
sudo udevadm control --reload
echo "✅ Arduino ready"

# Final update
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
curl -fsSL "https://gitlab.com/ezraravinmateus/dotfiles/-/raw/HEAD/.zshrc" >~/.zshrc

# Reboot prompt
echo "🎉 Setup complete! Rebooting in 5 seconds..."
sleep 5
sudo reboot