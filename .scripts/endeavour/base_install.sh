#!/bin/bash
# base_install.sh - Main Installation Orchestrator

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/cli_colors.sh"

# Enable error handling and verbose output
set -e
set -o pipefail
exec > >(tee -i setup.log) 2>&1

##############################################
### Cleanup Function
##############################################
cleanup() {
  local exit_status=$?
  if [ $exit_status -eq 0 ]; then
    if [ -z "${REBOOT_CHOICE+x}" ]; then
      print_success "Installation successful. Setup.log preserved."
    else
      [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]] &&
        print_success "System will reboot." ||
        print_success "Setup.log preserved."
    fi
  else
    print_error "Installation failed. Last 20 lines from setup.log:"
    tail -n 20 setup.log
  fi
}
trap cleanup EXIT

##############################################
### Core Configuration Functions
##############################################

prompt_ssh() {
  print_header "🔑 SSH Configuration"
  read -p "Use SSH for Git operations? (y/n): " USE_SSH
  if [[ "$USE_SSH" =~ ^[Yy]$ ]]; then
    print_section "Setting up SSH..."
    if [[ ! -f ~/.ssh/id_ed25519 ]]; then
      ssh-keygen -t ed25519 -C "Rave's PC" -N "" -f ~/.ssh/id_ed25519
      eval "$(ssh-agent -s)"
      ssh-add ~/.ssh/id_ed25519
      print_success "SSH key generated"
    else
      print_warning "SSH key exists"
    fi
    GIT_CLONE_PREFIX="git@gitlab.com:"
  else
    GIT_CLONE_PREFIX="https://gitlab.com/"
  fi
}

configure_system() {
  print_header "⚙️ System Configuration"
  sudo systemctl enable --now bluetooth && print_success "Bluetooth enabled"
}

##############################################
### Script Execution Functions
##############################################

run_script() {
  local script_name=$1
  local script_path="$SCRIPT_DIR/$script_name"

  if [[ -f "$script_path" && -x "$script_path" ]]; then
    print_header "🏃 Running $script_name"
    "$script_path" || {
      print_error "$script_name failed"
      return 1
    }
  else
    print_error "Script not found/executable: $script_name"
    return 1
  fi
}

execute_install_phase() {
  local phase_name=$1
  shift
  local scripts=("$@")

  print_header "🚀 Starting $phase_name Phase"
  for script in "${scripts[@]}"; do
    run_script "$script" || {
      print_warning "Continuing despite $script failure"
      continue
    }
  done
}

##############################################
### Main Installation Flow
##############################################

main() {
  # Keep sudo alive
  sudo -v
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  # Initial configuration
  prompt_ssh
  configure_system
  run_script "configure_git.sh"

  # Core installation phases
  execute_install_phase "Environment" \
    "setup_shell.sh" \
    "setup_linux.sh"

  execute_install_phase "Development" \
    "setup_dev_env.sh" \
    "setup_mobile.sh" \
    "setup_ai.sh"

  execute_install_phase "Applications" \
    "setup_apps.sh" \
    "setup_gpu_driver.sh"

  # Finalization
  run_script "configure_dotfiles.sh"
  run_script "finalize_setup.sh"

  # Completion
  print_header "🎉 Installation Complete!"
  read -p "Reboot now? (y/n): " REBOOT_CHOICE
  [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]] && sudo reboot ||
    print_success "Changes may require restart"
}

# Execute only if run directly
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
