#!/bin/bash
# finalize_setup.sh - System Finalization

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

finalize_setup() {
  print_header "🔚 Finalizing Setup"

  # System update
  print_section "System Update"
  sudo pacman -Syu --noconfirm &&
    print_success "System updated" ||
    print_error "System update failed"

  # Cleanup
  print_section "Cleaning Up"
  sudo pacman -Sc --noconfirm &&
    print_success "Package cache cleaned" ||
    print_warning "Cleanup failed"

  # Check for reboot recommendation
  if [[ -f /var/run/reboot-required ]]; then
    print_section "Reboot Recommended"
    read -p "Reboot now? (y/n): " REBOOT_CHOICE
    [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]] && sudo reboot
  fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && finalize_setup
