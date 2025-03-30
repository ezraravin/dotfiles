#!/bin/bash
# NVIDIA Driver Auto-Installer for Debian 12

# Check if root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

# Enable non-free repositories
echo "🔄 Enabling non-free repositories..."
sed -i '/^deb.*main/ s/$/ contrib non-free non-free-firmware/' /etc/apt/sources.list
sed -i '/^deb-src.*main/ s/$/ contrib non-free non-free-firmware/' /etc/apt/sources.list

# Add backports as fallback
echo "📦 Adding backports repository..."
echo "deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware" >/etc/apt/sources.list.d/backports.list

# Update packages
echo "🔄 Updating package lists..."
apt update -y

# Install prerequisites
echo "📦 Installing prerequisites..."
apt install -y firmware-misc-nonfree nvidia-detect

# Detect and install appropriate driver
echo "🔍 Detecting NVIDIA GPU..."
DRIVER_PACKAGE=$(nvidia-detect | grep "recommended" | awk '{print $4}')

if [ -z "$DRIVER_PACKAGE" ]; then
  echo "❌ No NVIDIA GPU detected or driver package not found"
  exit 1
fi

echo "💿 Installing $DRIVER_PACKAGE..."
apt install -y "$DRIVER_PACKAGE"

# Install CUDA toolkit if desired
read -p "Install CUDA toolkit? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "🧮 Installing CUDA toolkit..."
  apt install -y nvidia-cuda-toolkit
fi

# Configure mkinitramfs
echo "⚙️ Updating initramfs..."
update-initramfs -u

echo "✅ Installation complete! A reboot is required."
read -p "Reboot now? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  reboot
fi
