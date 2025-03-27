#!/bin/bash
# prompt_ssh.sh - Interactive SSH Key Setup
# Description:
#   Configures SSH keys for secure Git operations with:
#   - Customizable PC name in key comment
#   - ED25519 key generation
#   - SSH agent setup
#   - Clear public key display
# Usage:
#   Run during system setup or standalone for SSH configuration

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

prompt_ssh() {
  print_header "🔐 SSH Key Configuration"

  # Interactive confirmation
  read -p "Configure SSH for Git operations? [y/N]: " USE_SSH
  [[ "$USE_SSH" =~ ^[Yy]$ ]] || return 0

  # Get PC identifier
  print_section "🖥️  PC Identification"
  local current_pc_name=$(hostname)
  read -p "Enter a name for this PC [$current_pc_name]: " PC_NAME
  PC_NAME=${PC_NAME:-$current_pc_name}

  # Key configuration
  local ssh_key="$HOME/.ssh/id_ed25519"
  local key_comment="$PC_NAME $(date +%Y-%m-%d)"

  if [[ ! -f "$ssh_key" ]]; then
    print_section "🔑 Generating SSH Key"
    echo -e "${BLUE}Creating ED25519 key (secure by default)${NC}"

    ssh-keygen -t ed25519 \
      -C "$key_comment" \
      -N "" \
      -f "$ssh_key" &&
      {
        # Start and configure SSH agent
        eval "$(ssh-agent -s)" >/dev/null
        ssh-add "$ssh_key"
        print_success "SSH key generated: ${YELLOW}$ssh_key${NC}"
        GIT_CLONE_PREFIX="git@gitlab.com:"
      } || {
      print_error "Key generation failed"
      return 1
    }
  else
    print_warning "Existing SSH key found: ${YELLOW}$ssh_key${NC}"
    local existing_comment=$(grep -oP ' \K.*' "$ssh_key.pub")
    echo -e "Current key comment: ${BLUE}$existing_comment${NC}"
  fi

  # Key display and instructions
  print_section "📋 Public Key Configuration"
  echo -e "${GREEN}Add this key to your Git hosting services:${NC}"
  echo -e "${BLUE}"
  cat "${ssh_key}.pub"
  echo -e "${NC}"
  echo -e "\n${YELLOW}Steps to configure:"
  echo "1. Copy the key above"
  echo "2. Go to your Git provider's SSH settings"
  echo "3. Add as a new SSH key"
  echo -e "4. Test with: ${BLUE}ssh -T git@gitlab.com${NC}${NC}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && prompt_ssh
