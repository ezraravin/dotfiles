#!/bin/bash
# setup_apps.sh - User Applications

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_apps() {
  print_header "📦 Applications"

  local apps=(
    brave-bin
    vlc
    obs-studio
  )

  for app in "${apps[@]}"; do
    install_or_skip "$app" "yay -S --noconfirm $app" "$app"
  done

  print_success "Applications installed"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_apps
