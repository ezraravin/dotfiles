#!/bin/bash
# setup_sway.sh - Sway Setup

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_sway() {
  print_header "🌊 Sway Setup"

  local packages=(
    sway
    swaybg
    swaylock-effects
    waybar
    wofi
    grim
    slurp
  )

  for pkg in "${packages[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  print_success "Sway installed"
  echo "Configure at ~/.config/sway/config"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_sway
