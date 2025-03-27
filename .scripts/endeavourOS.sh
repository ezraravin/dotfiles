#!/bin/bash
# Simple System Setup with one-time sudo

# Unified function to check if something is installed
is_installed() {
  command -v "$1" >/dev/null 2>&1 || pacman -Qi "$1" &>/dev/null
}

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
if ! is_installed sddm; then
  echo "🖥️ SDDM Setup"
  sudo pacman -S --noconfirm sddm
  sudo systemctl enable --now sddm
  echo "✅ SDDM installed"
fi

# SETUP - GPU DRIVER
echo "🔍 GPU Detection"
if lspci | grep -i "VGA.*NVIDIA"; then
  echo "🟢 NVIDIA detected"
  if ! is_installed nvidia-dkms; then
    sudo pacman -S --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
    # For CUDA support (required for LLMs)
    sudo pacman -S --noconfirm cuda cudnn
    sudo mkinitcpio -P
  fi
elif lspci | grep -i "VGA.*AMD"; then
  echo "🔴 AMD detected"
  if ! is_installed mesa; then
    sudo pacman -S --noconfirm mesa vulkan-radeon lib32-vulkan-radeon
  fi
elif lspci | grep -i "VGA.*Intel"; then
  echo "🔵 Intel detected"
  if ! is_installed mesa; then
    sudo pacman -S --noconfirm mesa vulkan-intel lib32-vulkan-intel
  fi
fi
echo "✅ GPU setup complete - reboot required"

# SETUP - LINUX
echo "🐧 Core Linux Setup"
for pkg in eza bat ripgrep fd nautilus btop cava fastfetch curl wget blueman; do
  if ! is_installed "$pkg"; then
    sudo pacman -S --noconfirm "$pkg"
  fi
done
echo "✅ Core system tools installed"

# SETUP - HYPRLAND
echo "🌌 Hyprland Setup"
for pkg in hyprland hyprpaper hyprlock waybar wofi grim slurp wl-clipboard; do
  if ! is_installed "$pkg"; then
    sudo pacman -S --noconfirm "$pkg"
  fi
done
echo "✅ Hyprland installed"

# SETUP - SWAY
echo "🌊 Sway Setup"
for pkg in sway swaybg swaylock-effects waybar wofi grim slurp wl-clipboard; do
  if ! is_installed "$pkg"; then
    sudo pacman -S --noconfirm "$pkg"
  fi
done
echo "✅ Sway installed - configure ~/.config/sway/config"

# SETUP - DEV ENVIRONMENT
echo "👨💻 Dev Environment Setup"
for pkg in nodejs npm python yarn pnpm lazygit docker docker-compose; do
  if ! is_installed "$pkg"; then
    sudo pacman -S --noconfirm "$pkg"
  fi
done
if ! is_installed lazydocker; then
  yay -S --noconfirm lazydocker
fi
if ! is_installed php; then
  /bin/bash -c "$(curl -fsSL https://php.new/install/linux)"
fi
if ! is_installed bun; then
  curl -fsSL https://bun.sh/install | bash
fi
echo "✅ Dev tools installed"

# SETUP - SHELL
echo "🐚 Shell Setup"
for pkg in zsh zsh-syntax-highlighting zsh-autosuggestions zsh-completions zoxide fzf thefuck; do
  if ! is_installed "$pkg"; then
    sudo pacman -S --noconfirm "$pkg"
  fi
done
if ! is_installed oh-my-posh; then
  curl -s https://ohmyposh.dev/install.sh | bash -s
fi
if [ ! -d ~/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
if [ "$SHELL" != "$(which zsh)" ]; then
  sudo chsh -s $(which zsh)
fi
echo "✅ Shell configured"

# SETUP - AI
echo "🤖 AI Development Setup"
if ! is_installed ollama; then
  echo "🦙 Installing Ollama"
  curl -fsSL https://ollama.com/install.sh | sh
fi
if ! is_installed chatbox-bin; then
  echo "💬 Installing Chatbox"
  yay -S --noconfirm chatbox-bin
fi
echo "📥 Downloading AI Models"
ollama pull deepseek-coder-v2
ollama pull deepseek-v2
ollama pull deepseek-r1
echo "✅ AI tools configured"

# SETUP - APPS
echo "🖥️ Desktop Applications Setup"
if ! is_installed brave-browser; then
  echo "🌐 Installing Brave Browser"
  curl -fsS https://dl.brave.com/install.sh | sh
fi
if ! is_installed whatsapp-for-linux; then
  yay -S --noconfirm whatsapp-for-linux
fi
if ! is_installed spotify; then
  echo "🎵 Installing Spotify"
  yay -S --noconfirm spotify spotify-adblock
fi
for pkg in vlc obs-studio; do
  if ! is_installed "$pkg"; then
    sudo pacman -S --noconfirm "$pkg"
  fi
done
echo "✅ Applications installed"

# SETUP - ARDUINO
echo "⚡ Arduino Setup"
if ! is_installed arduino-ide; then
  yay -S --noconfirm arduino-ide
  sudo usermod -a -G uucp,tty $USER
  sudo curl -o /etc/udev/rules.d/60-arduino.rules https://raw.githubusercontent.com/arduino/ArduinoCore-avr/master/60-arduino-avr-core.rules
  sudo udevadm control --reload
fi
echo "✅ Arduino ready"

# CONFIG - Update system
sudo pacman -Syu --noconfirm
sudo pacman -Sc --noconfirm

read -p "Setup Complete. Reboot now? [y/N]: " reboot_choice
[[ "$reboot_choice" =~ ^[Yy]$ ]] && sudo reboot
