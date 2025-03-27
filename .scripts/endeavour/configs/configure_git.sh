#!/bin/bash
# configure_git.sh - Git Configuration Script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

configure_git() {
  print_header "🔧 Git Configuration"

  # Check if already configured
  if git config --global --get user.email &>/dev/null &&
    git config --global --get user.name &>/dev/null &&
    git config --global --get init.defaultBranch &>/dev/null; then
    print_warning "Git already configured - skipping"
    return 0
  fi

  # Interactive setup
  print_section "User Configuration"
  read -p "Enter Git email: " GIT_EMAIL
  read -p "Enter Git name: " GIT_NAME
  read -p "Enter default branch (main/master): " GIT_BRANCH

  # Apply configuration
  git config --global user.email "$GIT_EMAIL" &&
    git config --global user.name "$GIT_NAME" &&
    git config --global init.defaultBranch "$GIT_BRANCH" &&
    print_success "Git configured" ||
    print_error "Git configuration failed"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && configure_git
