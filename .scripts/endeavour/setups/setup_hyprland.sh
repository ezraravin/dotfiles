#!/bin/bash
# setup_hyprland.sh - Hyprland Wayland Compositor
# Description:
#   Installs Hyprland and essential components:
#   - Core compositor
#   - Utilities (hyprpaper, hyprlock)
#   - Waybar integration
#   - Required portals and utilities
#   - Wayland clipboard

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

install_hyprland() {
  print_header "🌌 Hyprland Installation"

  local core_packages=(
    hyprland     # Main compositor
    hyprpaper    # Wallpaper utility
    hyprlock     # Screen locker
    waybar       # Hyprland-compatible status bar
    wofi         # Application launcher
    grim         # Screenshot tool
    slurp        # Region selection
    wl-clipboard # Clipboard for Wayland
  )

  # Install main packages
  for pkg in "${core_packages[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  # Required portals
  print_section "🚪 XDG Desktop Portal"
  install_or_skip "xdg-desktop-portal-hyprland" \
    "sudo pacman -S --noconfirm xdg-desktop-portal-hyprland" \
    "Hyprland Portal"

  print_success "Hyprland installed"
  echo -e "${YELLOW}Next steps:"
  echo "1. Configure: ~/.config/hypr/hyprland.conf"
  echo "2. Examples: https://wiki.hyprland.org/Configuring/${NC}"
}

main() {
  install_hyprland
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
