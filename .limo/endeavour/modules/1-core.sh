# Bluetooth & Wifi
echo "ᛒ Enabling Bluetooth"
sudo systemctl enable --now bluetooth

# Brightness Control
sudo pacman -S --noconfirm brightnessctl
sudo usermod -aG video $USER

# Core Tools
echo "🐧 Core Setup"
sudo pacman -S --noconfirm zip eza bat ripgrep fd nautilus btop cava fastfetch blueman kitty xorg-xwayland
yay -S --noconfirm wlogout
echo "✅ Core tools installed"
