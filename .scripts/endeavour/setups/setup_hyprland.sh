#!/bin/bash
# setup_hyprland.sh - Hyprland-specific packages

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/cli_colors.sh"

install_hyprland() {
  print_header "🌌 Installing Hyprland Compositor"

  local core_packages=(
    hyprland
    hyprpaper       # Hyprland's native wallpaper tool
    hyprlock        # Hyprland's native screen locker
    hypridle        # Hyprland's idle daemon
    waybar-hyprland # Hyprland-compatible Waybar
    wofi            # Application launcher
  )

  for pkg in "${core_packages[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  print_section "Configuring Essentials"
  install_or_skip "xdg-desktop-portal-hyprland" "sudo pacman -S --noconfirm xdg-desktop-portal-hyprland" "XDG Desktop Portal"
  install_or_skip "grim" "sudo pacman -S --noconfirm grim" "Screenshot Utility"
  install_or_skip "slurp" "sudo pacman -S --noconfirm slurp" "Region Selector"

  print_success "Hyprland installed successfully"
  echo -e "${YELLOW}Next steps:"
  echo "1. Create config: ~/.config/hypr/hyprland.conf"
  echo "2. Example config: https://wiki.hyprland.org/Configuring/Example-config/${NC}"
}

main() {
  install_hyprland
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
