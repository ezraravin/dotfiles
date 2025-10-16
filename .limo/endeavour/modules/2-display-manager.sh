# Display Manager
echo "🖥️ SDDM Setup"
sudo pacman -S --noconfirm sddm
sudo systemctl enable sddm
echo "✅ SDDM installed"
