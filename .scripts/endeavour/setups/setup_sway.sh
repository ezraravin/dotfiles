#!/bin/bash
# setup_sway.sh - Sway Wayland Compositor
# Description:
#   Installs Sway and essential components:
#   - Core compositor
#   - Screen locking utilities
#   - Waybar integration
#   - Screenshot tools

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_sway() {
  print_header "🌊 Sway Installation"

  local packages=(
    sway             # Compositor
    swaybg           # Wallpaper
    swaylock-effects # Screen locker
    waybar           # Status bar
    wofi             # App launcher
    grim             # Screenshots
    slurp            # Region selection
  )

  # Install packages
  for pkg in "${packages[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  print_success "Sway installed"
  echo -e "${YELLOW}Configure at: ~/.config/sway/config${NC}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_sway
