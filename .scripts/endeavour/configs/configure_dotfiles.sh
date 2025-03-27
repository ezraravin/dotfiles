#!/bin/bash
# configure_dotfiles.sh - Manages dotfiles installation and configuration
# Description:
#   Clones dotfiles from a Git repository and synchronizes them to the home directory.
#   Handles error cases and provides user feedback through colored output.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh" # Load color output functions

configure_dotfiles() {
  print_header "🎛️ Dotfiles Configuration"

  # Configuration variables
  local dotfiles_dir="$HOME/dotfiles"                                                    # Temporary clone directory
  local clone_url="${GIT_CLONE_PREFIX:-https://gitlab.com/}ezraravinmateus/dotfiles.git" # Fallback to HTTPS if SSH not configured

  # Check for existing dotfiles
  if [[ -d "$dotfiles_dir" ]]; then
    print_warning "Dotfiles already exist at $dotfiles_dir"
    return 0 # Exit gracefully if already configured
  fi

  # Clone operation
  print_section "Cloning Dotfiles Repository"
  if git clone "$clone_url" "$dotfiles_dir"; then
    # Successful clone - sync files to home directory
    rsync -a "$dotfiles_dir/" "$HOME/" && # Preserve permissions and attributes
      rm -rf "$dotfiles_dir" &&           # Clean up temporary directory
      print_success "Dotfiles successfully applied" ||
      print_error "Failed to apply dotfiles"
  else
    print_error "Failed to clone dotfiles repository"
    return 1 # Return error status
  fi
}

# Execute only if run directly (not sourced)
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && configure_dotfiles
