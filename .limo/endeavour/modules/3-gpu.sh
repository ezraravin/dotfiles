# GPU Drivers
echo "🔍 GPU Detection"
if lspci | grep -i "VGA.*NVIDIA"; then
  echo "🟢 NVIDIA detected"
  sudo pacman -S --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
  sudo mkinitcpio -P
elif lspci | grep -i "VGA.*AMD"; then
  echo "🔴 AMD detected"
  sudo pacman -S --noconfirm mesa vulkan-radeon lib32-vulkan-radeon
elif lspci | grep -i "VGA.*Intel"; then
  echo "🔵 Intel detected"
  sudo pacman -S --noconfirm mesa vulkan-intel lib32-vulkan-intel
fi
echo "✅ GPU setup complete"