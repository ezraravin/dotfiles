#!/bin/bash
# setup_linux.sh - Core Linux Setup

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_linux() {
  print_header "🐧 Core Linux Setup"

  local core_packages=(
    git
    neovim
    tmux
    eza
    bat
    ripgrep
    fd
    curl
    wget
    htop
    btop
    ncdu
    lm_sensors
    usbutils
    udisks2
    ntfs-3g
  )

  for pkg in "${core_packages[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  print_success "Core Linux setup complete"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_linux
