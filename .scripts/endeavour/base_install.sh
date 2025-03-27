#!/bin/bash
# base_install.sh - Comprehensive System Installation and Configuration Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/cli_colors.sh"

# Enable strict error handling and verbose logging
set -e
set -o pipefail

# Setup logging with timestamping if available
if command -v ts >/dev/null; then
  exec > >(ts '[%Y-%m-%d %H:%M:%S]' | tee -a setup.log)
else
  exec > >(while read -r line; do echo "[$(date '+%Y-%m-%d %H:%M:%S')] $line"; done | tee -a setup.log)
fi

# Enable parallel package downloads for faster installations
sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

##############################################
### Configuration Functions
##############################################

configure_dotfiles() {
  print_header "🎛️ Dotfiles Configuration"
  local dotfiles_dir="$HOME/dotfiles"
  local clone_url="${GIT_CLONE_PREFIX:-https://gitlab.com/}ezraravinmateus/dotfiles.git"

  if [[ -d "$dotfiles_dir" ]]; then
    print_warning "Dotfiles already exist at $dotfiles_dir"
    return 0
  fi

  print_section "Cloning Dotfiles Repository"
  if git clone "$clone_url" "$dotfiles_dir"; then
    rsync -av "$dotfiles_dir/" "$HOME/" &&
      rm -rf "$dotfiles_dir" &&
      print_success "Dotfiles successfully synchronized to home directory" ||
      print_error "Failed to apply dotfiles"
  else
    print_error "Failed to clone dotfiles repository"
    return 1
  fi
}

configure_git() {
  print_header "🔧 Git Configuration"

  # Check for existing configuration
  if git config --global --get user.email &>/dev/null &&
    git config --global --get user.name &>/dev/null &&
    git config --global --get init.defaultBranch &>/dev/null; then
    print_warning "Git configuration already exists - skipping setup"
    return 0
  fi

  # Interactive configuration
  print_section "User Identity Setup"
  read -rp "Enter Git email (for commits): " GIT_EMAIL
  read -rp "Enter Git name (for commits): " GIT_NAME
  read -rp "Enter default branch name [main]: " GIT_BRANCH
  GIT_BRANCH=${GIT_BRANCH:-main} # Default to 'main' if empty

  # Apply configuration
  git config --global user.email "$GIT_EMAIL" &&
    git config --global user.name "$GIT_NAME" &&
    git config --global init.defaultBranch "$GIT_BRANCH" &&
    print_success "Git configuration saved" ||
    print_error "Failed to configure Git settings"
}

configure_system() {
  print_header "⚙️ System Configuration"

  # Bluetooth Service
  print_section "Bluetooth Service Setup"
  if sudo systemctl enable --now bluetooth; then
    print_success "Bluetooth service activated"
  else
    print_error "Failed to configure Bluetooth"
  fi

  # Time Synchronization
  print_section "Network Time Protocol (NTP)"
  if sudo timedatectl set-ntp true; then
    print_success "Time synchronization enabled"
  else
    print_warning "NTP configuration failed (network time may be inaccurate)"
  fi

  # Firewall Configuration
  print_section "Firewall Setup"
  if ! sudo pacman -Qs firewalld >/dev/null; then
    if sudo pacman -S --noconfirm firewalld && sudo systemctl enable --now firewalld; then
      print_success "Firewall service enabled"
    else
      print_warning "Firewall setup incomplete (manual configuration needed)"
    fi
  else
    print_warning "Firewalld already installed - skipping configuration"
  fi
}

##############################################
### Utility Functions
##############################################

cleanup() {
  local exit_status=$?
  if [ $exit_status -eq 0 ]; then
    if [ -z "${REBOOT_CHOICE+x}" ]; then
      print_success "✅ Installation successful. Setup.log preserved."
    else
      [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]] &&
        print_success "🔄 System will reboot to apply changes." ||
        print_success "📋 Setup.log preserved. Reboot recommended."
    fi
  else
    print_error "❌ Installation failed. Last 20 lines from setup.log:"
    tail -n 20 setup.log
    print_warning "⚠️  Check setup.log for detailed error information"
  fi
}

run_script() {
  local script_name=$1
  local script_path="$SCRIPT_DIR/$script_name"

  if [[ -f "$script_path" && -x "$script_path" ]]; then
    print_header "🏃 Running $script_name"
    if "$script_path"; then
      return 0
    else
      print_error "$script_name failed with exit code $?"
      return 1
    fi
  else
    print_error "Script not found or not executable: $script_name"
    return 1
  fi
}

execute_install_phase() {
  local phase_name=$1
  shift
  local scripts=("$@")

  print_header "🚀 Starting $phase_name Phase"
  for script in "${scripts[@]}"; do
    if ! run_script "$script"; then
      print_warning "⚠️  Continuing despite $script failure"
      sleep 2 # Pause to ensure user sees the warning
    fi
  done
}

##############################################
### Main Installation Flow
##############################################

main() {
  # Keep sudo session alive throughout installation
  print_section "🔐 Maintaining Sudo Session"
  sudo -v
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  # Initial System Configuration
  print_header "⚙️ System Configuration Phase"
  configure_dotfiles
  configure_git
  configure_system

  # Core Installation Phases
  execute_install_phase "Environment Setup" \
    "./config/setup_shell.sh" \
    "./config/setup_linux.sh"

  execute_install_phase "Development Environment" \
    "./setups/setup_dev_env.sh" \
    "./setups/setup_mobile.sh" \
    "./setups/setup_ai.sh"

  execute_install_phase "Application Installation" \
    "./setups/setup_apps.sh" \
    "./setups/setup_gpu.sh"

  execute_install_phase "Finalization" \
    "./utilities/finalize_setup.sh"

  # Installation Complete
  print_header "🎉 Installation Complete!"
  read -rp "Reboot now to apply all changes? (y/n): " REBOOT_CHOICE
  if [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]]; then
    sudo reboot
  else
    print_success "Changes may require restart. Log saved to setup.log"
  fi
}

# Execute only if run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  trap cleanup EXIT
  main "$@"
fi
