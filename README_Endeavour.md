# Install NVIDIA
```bash
sudo pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
```

# Start Bluetooth Session & Enable Bluetooth By Default
```bash
sudo systemctl start bluetooth
sudo systemctl enable bluetooth
```
# Install Hyprland
```bash
sudo pacman -S --noconfirm hyprland
```