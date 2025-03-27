#!/bin/bash
# ==============================================
# Core Linux System Configuration
#
# Description:
#   Installs essential system utilities for:
#   - File management and navigation
#   - System monitoring and diagnostics
#   - Network and hardware management
#   - Storage and device utilities
# ==============================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_linux() {
  print_header "🐧 Core Linux System Setup"

  # ======================
  # File Management Tools
  # ======================
  print_section "📂 File Management Utilities"
  install_or_skip "eza" "sudo pacman -S --noconfirm eza" "Modern ls replacement"
  install_or_skip "bat" "sudo pacman -S --noconfirm bat" "Syntax-highlighting cat"
  install_or_skip "ripgrep" "sudo pacman -S --noconfirm ripgrep" "Fast grep alternative"
  install_or_skip "fd" "sudo pacman -S --noconfirm fd" "Simple find replacement"
  install_or_skip "nautilus" "sudo pacman -S --noconfirm nautilus" "GNOME File Manager"

  # ======================
  # System Monitoring
  # ======================
  print_section "📊 System Monitoring Tools"
  install_or_skip "btop" "sudo pacman -S --noconfirm btop" "Interactive system monitor"
  install_or_skip "ncdu" "sudo pacman -S --noconfirm ncdu" "Disk usage analyzer"
  install_or_skip "lm_sensors" "sudo pacman -S --noconfirm lm_sensors" "Hardware monitoring"
  install_or_skip "cava" "sudo pacman -S --noconfirm cava" "Audio visualizer"
  install_or_skip "fastfetch" "sudo pacman -S --noconfirm fastfetch" "System information tool"

  # ======================
  # Network & Connectivity
  # ======================
  print_section "🌐 Network Utilities"
  install_or_skip "curl" "sudo pacman -S --noconfirm curl" "Data transfer tool"
  install_or_skip "wget" "sudo pacman -S --noconfirm wget" "File download utility"
  install_or_skip "blueman" "sudo pacman -S --noconfirm blueman" "Bluetooth manager"

  # ======================
  # Storage & Devices
  # ======================
  print_section "💾 Storage Management"
  install_or_skip "udisks2" "sudo pacman -S --noconfirm udisks2" "Disk management"
  install_or_skip "ntfs-3g" "sudo pacman -S --noconfirm ntfs-3g" "NTFS filesystem support"
  install_or_skip "usbutils" "sudo pacman -S --noconfirm usbutils" "USB device utilities"

  print_success "Core system setup completed successfully"
  echo -e "${YELLOW}Note: Some tools may require additional configuration:"
  echo "- Run 'sensors-detect' for hardware monitoring"
  echo "- Configure blueman for Bluetooth devices"
  echo "- Add user to storage group for disk management${NC}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_linux
