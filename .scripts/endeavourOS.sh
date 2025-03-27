#!/bin/bash
# Simple System Setup with one-time sudo

# Ask for sudo once and keep it alive in background
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# GIT - SSH Setup (runs as normal user)
read -p "Use SSH for Git? [y/N]: " ssh_choice
if [[ "$ssh_choice" =~ ^[Yy]$ ]]; then
  read -p "Name for SSH key: " key_name
  ssh-keygen -t ed25519 -C "$key_name" -N "" -f ~/.ssh/id_ed25519
  echo "Public key (add to Git account):"
  cat ~/.ssh/id_ed25519.pub
  read -p "Press Enter after adding key to Git account..."
  GIT_CLONE_PREFIX="git@gitlab.com:"
else
  GIT_CLONE_PREFIX="https://gitlab.com/"
fi

# GIT - Dotfiles (runs as normal user)
[ ! -d ~/dotfiles ] && git clone $GIT_CLONE_PREFIX/ezraravinmateus/dotfiles.git ~/dotfiles &&
  cp -r ~/dotfiles/. ~/ && rm -rf ~/dotfiles

# GIT - Git Config (runs as normal user)
if ! git config --global user.email &>/dev/null; then
  git config --global user.email "ezraravin@proton.me"
  git config --global user.name "Rave"
  git config --global init.defaultBranch main
fi

# CONFIG - Enable bluetooth
sudo systemctl enable --now bluetooth

# SETUP - DISPLAY MANAGER
echo "🖥️ SDDM Setup"
sudo pacman -S --noconfirm sddm
sudo systemctl enable --now sddm
echo "✅ SDDM installed"

# SETUP - GPU DRIVER
echo "🔍 GPU Detection"
if lspci | grep -i "VGA.*NVIDIA"; then
  echo "🟢 NVIDIA detected"
  sudo pacman -S --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
  # For CUDA support (required for LLMs)
  sudo pacman -S --noconfirm cuda cudnn
  sudo mkinitcpio -P
elif lspci | grep -i "VGA.*AMD"; then
  echo "🔴 AMD detected"
  sudo pacman -S --noconfirm mesa vulkan-radeon lib32-vulkan-radeon
elif lspci | grep -i "VGA.*Intel"; then
  echo "🔵 Intel detected"
  sudo pacman -S --noconfirm mesa vulkan-intel lib32-vulkan-intel
fi
echo "✅ GPU setup complete - reboot required"

# SETUP - LINUX
echo "🐧 Core Linux Setup"
sudo pacman -S --noconfirm eza bat ripgrep fd nautilus
sudo pacman -S --noconfirm btop cava fastfetch
sudo pacman -S --noconfirm curl wget blueman
echo "✅ Core system tools installed"

# SETUP - HYPRLAND
echo "🌌 Hyprland Setup"
sudo pacman -S --noconfirm hyprland hyprpaper hyprlock waybar wofi grim slurp wl-clipboard
echo "✅ Hyprland installed"

# SETUP - SWAY
echo "🌊 Sway Setup"
sudo pacman -S --noconfirm sway swaybg swaylock-effects
sudo pacman -S --noconfirm waybar wofi grim slurp wl-clipboard
echo "✅ Sway installed - configure ~/.config/sway/config"

# SETUP - DEV ENVIRONMENT
echo "👨💻 Dev Environment Setup"
sudo pacman -S --noconfirm nodejs npm python yarn pnpm lazygit docker docker-compose
yay -S lazydocker
/bin/bash -c "$(curl -fsSL https://php.new/install/linux)"
curl -fsSL https://bun.sh/install | bash
echo "✅ Dev tools installed"

# SETUP - SHELL
echo "🐚 Shell Setup"
sudo pacman -S --noconfirm zsh zsh-syntax-highlighting zsh-autosuggestions zsh-completions
sudo pacman -S --noconfirm zoxide fzf thefuck
curl -s https://ohmyposh.dev/install.sh | bash -s
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
sudo chsh -s $(which zsh)
echo "✅ Shell configured"

# SETUP - AI
echo "🤖 AI Development Setup"
echo "🦙 Installing Ollama"
curl -fsSL https://ollama.com/install.sh | sh
echo "💬 Installing Chatbox"
yay -S --noconfirm chatbox-bin
echo "📥 Downloading AI Models"
ollama pull deepseek-coder-v2
ollama pull deepseek-v2
ollama pull deepseek-r1
echo "✅ AI tools configured"

# SETUP - APPS
echo "🖥️ Desktop Applications Setup"
echo "🌐 Installing Browsers"
curl -fsS https://dl.brave.com/install.sh | sh
yay -S --noconfirm whatsapp-for-linux
echo "🎵 Installing Music"
yay -S --noconfirm spotify spotify-adblock
echo "🎬 Installing Media"
sudo pacman -S --noconfirm vlc obs-studio
echo "✅ Applications installed"

# SETUP - ARDUINO
echo "⚡ Arduino Setup"
yay -S --noconfirm arduino-ide
sudo usermod -a -G uucp,tty $USER
sudo curl -o /etc/udev/rules.d/60-arduino.rules https://raw.githubusercontent.com/arduino/ArduinoCore-avr/master/60-arduino-avr-core.rules
sudo udevadm control --reload
echo "✅ Arduino ready"

# CONFIG - Update system
sudo pacman -Syu --noconfirm
sudo pacman -Sc --noconfirm

read -p "Setup Complete. Reboot now? [y/N]: " reboot_choice
[[ "$reboot_choice" =~ ^[Yy]$ ]] && sudo reboot
