#!/bin/bash
# setup_dev_env.sh - Development Environment Setup
# Description:
#   Installs core development tools including:
#   - Programming languages (Node.js, Python, Java, PHP)
#   - Package managers (Yarn, pnpm)
#   - Development tools (Docker, Lazygit)
#   - Bun JavaScript runtime

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_dev() {
  print_header "👨💻 Development Environment Setup"

  # Core programming languages
  local langs=(
    nodejs      # JavaScript runtime
    npm         # Node package manager
    python      # Python interpreter
    jdk-openjdk # Java Development Kit
    php         # PHP runtime
    composer    # PHP dependency manager
  )

  # Development tools and utilities
  local tools=(
    yarn           # Alternative package manager
    pnpm           # Fast, disk-efficient package manager
    lazygit        # Terminal UI for Git
    docker         # Container platform
    docker-compose # Container orchestration
  )

  # Install all packages with error handling
  for pkg in "${langs[@]}" "${tools[@]}"; do
    install_or_skip "$pkg" "sudo pacman -S --noconfirm $pkg" "$pkg"
  done

  # Special installation for Bun (not in official repos)
  if ! command_exists bun; then
    print_section "Installing Bun Runtime"
    curl -fsSL https://bun.sh/install | bash
  fi

  print_success "Development environment configured"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_dev
