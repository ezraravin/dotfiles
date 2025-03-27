#!/bin/bash
# configure_system.sh - System Configuration

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

configure_system() {
  print_header "⚙️ System Configuration"

  # Bluetooth
  print_section "Bluetooth Setup"
  sudo systemctl enable --now bluetooth &&
    print_success "Bluetooth enabled" ||
    print_error "Failed to enable Bluetooth"

  # Time synchronization
  print_section "Time Sync"
  sudo timedatectl set-ntp true &&
    print_success "NTP enabled" ||
    print_warning "NTP setup failed"

  # Firewall (optional)
  if ! sudo pacman -Qs firewalld >/dev/null; then
    print_section "Firewall Setup"
    sudo pacman -S --noconfirm firewalld &&
      sudo systemctl enable --now firewalld &&
      print_success "Firewalld enabled" ||
      print_warning "Firewall setup skipped"
  fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && configure_system
