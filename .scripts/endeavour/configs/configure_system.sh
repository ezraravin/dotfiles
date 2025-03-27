#!/bin/bash
# configure_system.sh - System-level configuration
# Description:
#   Configures essential system services including:
#   - Bluetooth
#   - Time synchronization
#   - Firewall (optional)
#   Provides status feedback for each operation.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh" # Load color output functions

configure_system() {
  print_header "⚙️ System Configuration"

  # Bluetooth Configuration
  print_section "Bluetooth Service Setup"
  sudo systemctl enable --now bluetooth && # Enable and start immediately
    print_success "Bluetooth service activated" ||
    print_error "Failed to configure Bluetooth"

  # Time Synchronization
  print_section "Network Time Protocol (NTP)"
  sudo timedatectl set-ntp true && # Enable automatic time sync
    print_success "Time synchronization enabled" ||
    print_warning "NTP configuration failed (network time may be inaccurate)"

  # Optional Firewall Setup
  if ! sudo pacman -Qs firewalld >/dev/null; then
    print_section "Firewall Configuration"
    sudo pacman -S --noconfirm firewalld &&    # Install firewall
      sudo systemctl enable --now firewalld && # Activate firewall
      print_success "Firewall service enabled" ||
      print_warning "Firewall setup incomplete (manual configuration needed)"
  else
    print_section "Firewall Status"
    print_warning "Firewalld already installed - skipping configuration"
  fi
}

# Execute only if run directly (not sourced)
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && configure_system
