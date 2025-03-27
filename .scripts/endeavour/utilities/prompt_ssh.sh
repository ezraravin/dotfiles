#!/bin/bash
# prompt_ssh.sh - SSH Configuration

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

prompt_ssh() {
  print_header "🔐 SSH Setup"

  read -p "Configure SSH for Git? (y/n): " USE_SSH
  [[ "$USE_SSH" =~ ^[Yy]$ ]] || return 0

  local ssh_key="$HOME/.ssh/id_ed25519"

  if [[ ! -f "$ssh_key" ]]; then
    print_section "Generating SSH Key"
    ssh-keygen -t ed25519 -C "Rave's PC" -N "" -f "$ssh_key"
    eval "$(ssh-agent -s)"
    ssh-add "$ssh_key"
    print_success "SSH key generated"
    GIT_CLONE_PREFIX="git@gitlab.com:"
  else
    print_warning "SSH key exists at $ssh_key"
  fi

  print_section "Public Key"
  cat "${ssh_key}.pub"
  echo -e "\n${YELLOW}Add this key to your Git hosting service${NC}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && prompt_ssh
