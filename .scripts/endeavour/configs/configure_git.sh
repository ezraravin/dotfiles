#!/bin/bash
# configure_git.sh - Configures Git global settings
# Description:
#   Sets up Git user identity and default branch configuration.
#   Skips configuration if already set, with interactive prompts for new setup.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh" # Load color output functions

configure_git() {
  print_header "🔧 Git Configuration"

  # Check for existing configuration
  if git config --global --get user.email &>/dev/null &&
    git config --global --get user.name &>/dev/null &&
    git config --global --get init.defaultBranch &>/dev/null; then
    print_warning "Git configuration already exists - skipping setup"
    return 0 # Exit if already configured
  fi

  # Interactive configuration
  print_section "User Identity Setup"
  read -p "Enter Git email (for commits): " GIT_EMAIL
  read -p "Enter Git name (for commits): " GIT_NAME
  read -p "Enter default branch name [main/master]: " GIT_BRANCH

  # Apply configuration with error handling
  git config --global user.email "$GIT_EMAIL" &&
    git config --global user.name "$GIT_NAME" &&
    git config --global init.defaultBranch "$GIT_BRANCH" &&
    print_success "Git configuration saved" ||
    print_error "Failed to configure Git settings"
}

# Execute only if run directly (not sourced)
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && configure_git
