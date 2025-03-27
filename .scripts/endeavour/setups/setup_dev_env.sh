#!/bin/bash
# setup_dev_env.sh - Development Tools

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_dev() {
  print_header "👨💻 Development Environment"

  # Languages
  local langs=(
    nodejs
    npm
    python
    jdk-openjdk
    php
    composer
  )

  # Tools
  local tools=(
    yarn
    pnpm
    lazygit
    docker
    docker-compose
  )

  # Install all
  for pkg in "${langs[@]}" "${tools[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  # Bun (special install)
  if ! command_exists bun; then
    curl -fsSL https://bun.sh/install | bash
  fi

  print_success "Dev environment ready"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_dev
