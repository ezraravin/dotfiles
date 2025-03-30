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

# Core Tools
echo "🐧 Core Setup"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
sudo apt install -y golang cmake unzip git curl bat ripgrep nautilus btop blueman kitty xwayland
echo "Installing Fastfetch"
git clone https://github.com/fastfetch-cli/fastfetch.git
cd fastfetch
mkdir build && cd build
cmake ..
make
sudo make install
cd ~ && rm -rf fastfetch/
echo "Fastfetch installed"
echo "Installing Eza"
cargo install eza
echo "Eza installed"
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

# Window Managers
echo "🌌 Sway Setup"
sudo apt install -y sway waybar wofi grim slurp wl-clipboard
echo "✅ Sway installed"

# Display Manager (Ubuntu uses GDM by default)
echo "🖥️ Display Manager Setup"
sudo apt install -y sddm
sudo systemctl enable sddm
echo "✅ SDDM installed"

# GPU Drivers
echo "🔍 GPU Detection"
if lspci | grep -i "VGA.*AMD"; then
  echo "🔴 AMD detected"
  sudo apt install -y mesa-vulkan-drivers libvulkan1 ilvulkan-uts
elif lspci | grep -i "VGA.*Intel"; then
  echo "🔵 Intel detected"
  sudo apt install -y mesa-vulkan-drivers libvulkan1
fi
echo "✅ GPU setup complete"

# Dev Environment
echo "👨💻 Dev Setup"
sudo apt install -y nodejs npm python3 python3-pip yarnpkg docker.io docker-compose visidata
sudo npm install -g pnpm
/bin/bash -c "$(curl -fsSL https://php.new/install/linux)"
curl -fsSL https://bun.sh/install | bash
echo "✅ Dev tools installed"

# Shell
echo "🐚 Shell Setup"
sudo apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions tmux neovim zoxide fzf imagemagick ffmpeg fonts-jetbrains-mono
go install github.com/jesseduffield/lazygit@latest
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

# Applications
echo "🖥️ App Setup"
echo "🌐 Browsers"
curl -fsS https://dl.brave.com/install.sh | sh
echo "🎬 Media"
sudo apt install -y vlc obs-studio
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

