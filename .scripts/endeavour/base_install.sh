#!/bin/bash
# prompt_ssh.sh - SSH Key Configuration
# Description:
#   Interactive SSH key setup for Git operations:
#   - Generates ED25519 SSH key if none exists
#   - Starts SSH agent and adds key
#   - Displays public key for hosting services
# Configuration:
#   Sets GIT_CLONE_PREFIX environment variable
#   Uses "Rave's PC" as key comment
# Notes:
#   Requires user input for confirmation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

prompt_ssh() {
  print_header "🔑 SSH Key Configuration"

  # Prompt for SSH setup
  read -p "Configure SSH for Git operations? [y/N]: " USE_SSH
  [[ "$USE_SSH" =~ ^[Yy]$ ]] || return 0

  local ssh_key="$HOME/.ssh/id_ed25519"
  local key_comment="Rave's PC $(date +%Y-%m-%d)"

  # Key Generation
  if [[ ! -f "$ssh_key" ]]; then
    print_section "🔐 Generating New SSH Key"
    ssh-keygen -t ed25519 \
      -C "$key_comment" \
      -N "" \
      -f "$ssh_key" &&
      {
        eval "$(ssh-agent -s)"
        ssh-add "$ssh_key"
        print_success "SSH key generated and added to agent"
        GIT_CLONE_PREFIX="git@gitlab.com:"
      } || {
      print_error "Failed to generate SSH key"
      return 1
    }
  else
    print_warning "Existing SSH key found at: $ssh_key"
  fi

  # Key Display
  print_section "📋 Public Key (Add to Git Services)"
  echo -e "${BLUE}"
  cat "${ssh_key}.pub"
  echo -e "${NC}"
  echo -e "${YELLOW}Important: Add this key to your Git hosting provider:"
  echo "1. Copy the key above"
  echo "2. Paste in your Git account's SSH settings${NC}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && prompt_ssh
