#!/bin/bash
# setup_linux.sh - Core System Configuration
# Description:
#   Installs essential Linux utilities:
#   - File management (eza, bat)
#   - System monitoring (btop, lm_sensors)
#   - Network tools (curl, wget)
#   - Storage utilities (udisks2, ntfs-3g)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_linux() {
  print_header "🐧 Core Linux Setup"

  local core_packages=(
    # File management
    eza     # Modern ls replacement
    bat     # Cat with syntax highlighting
    ripgrep # Fast grep alternative
    fd      # Simple find replacement

    # System monitoring
    btop       # Enhanced system monitor
    ncdu       # Disk usage analyzer
    lm_sensors # Hardware monitoring

    # Network utilities
    curl # Data transfer
    wget # File downloader

    # Storage
    udisks2  # Disk management
    ntfs-3g  # NTFS support
    usbutils # USB device tools
  )

  # Install all packages
  for pkg in "${core_packages[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  print_success "Core system setup complete"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_linux
