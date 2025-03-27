#!/bin/bash
# setup_sway.sh - Sway-specific packages

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/cli_colors.sh"

install_sway() {
  print_header "🌊 Installing Sway Compositor"

  local core_packages=(
    sway
    swaybg           # Sway's wallpaper utility
    swaylock-effects # Sway's screen locker with effects
    swayidle         # Sway's idle management
    waybar           # Sway-compatible Waybar
    wofi             # Application launcher
  )

  for pkg in "${core_packages[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  print_success "Sway installed successfully"
  echo -e "${YELLOW}Next steps:"
  echo "1. Create config: ~/.config/sway/config"
  echo "2. Example config: https://github.com/swaywm/sway/wiki/Example-config/${NC}"
}

main() {
  install_sway
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
