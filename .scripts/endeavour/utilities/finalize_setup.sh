#!/bin/bash
# finalize_setup.sh - Post-Installation System Finalization
# Description:
#   Performs essential post-installation tasks:
#   - System updates
#   - Package cache cleanup
#   - Reboot recommendation check
# Usage:
#   Should be run after all other setup scripts complete
# Dependencies:
#   Requires sudo privileges
#   Checks for /var/run/reboot-required flag

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

finalize_setup() {
  print_header "🏁 Completing System Setup"

  # System Update
  print_section "🔄 Performing System Update"
  if sudo pacman -Syu --noconfirm; then
    print_success "System packages updated successfully"
  else
    print_error "System update failed - check network connection"
    return 1
  fi

  # Package Cleanup
  print_section "🧹 Cleaning Package Cache"
  if sudo pacman -Sc --noconfirm; then
    print_success "Freed disk space by cleaning package cache"
  else
    print_warning "Package cleanup encountered issues"
  fi

  # Reboot Check
  if [[ -f /var/run/reboot-required ]]; then
    print_section "⚠️ System Reboot Recommended"
    echo -e "${YELLOW}Some changes require a reboot to take effect${NC}"
    read -p "Reboot now? (y/N): " REBOOT_CHOICE
    if [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]]; then
      print_section "Rebooting System..."
      sudo reboot
    else
      print_warning "Postpone reboot at your own risk"
    fi
  fi

  print_success "System finalization complete"
  echo -e "${GREEN}All setup tasks finished successfully${NC}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && finalize_setup
