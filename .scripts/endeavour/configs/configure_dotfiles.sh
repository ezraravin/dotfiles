#!/bin/bash
# configure_dotfiles.sh - Dotfiles Configuration

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

configure_dotfiles() {
  print_header "🎛️ Dotfiles Configuration"

  local dotfiles_dir="$HOME/dotfiles"
  local clone_url="${GIT_CLONE_PREFIX:-https://gitlab.com/}ezraravinmateus/dotfiles.git"

  if [[ -d "$dotfiles_dir" ]]; then
    print_warning "Dotfiles already exist at $dotfiles_dir"
    return 0
  fi

  print_section "Cloning Dotfiles"
  if git clone "$clone_url" "$dotfiles_dir"; then
    rsync -a "$dotfiles_dir/" "$HOME/" &&
      rm -rf "$dotfiles_dir" &&
      print_success "Dotfiles applied" ||
      print_error "Dotfiles application failed"
  else
    print_error "Dotfiles clone failed"
    return 1
  fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && configure_dotfiles
