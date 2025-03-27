#!/bin/bash
# cli_colors.sh - Common functions for all scripts

# ANSI color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Output functions
print_header() {
  echo -e "${GREEN}\n===================================================================="
  echo -e "$1"
  echo -e "====================================================================${NC}"
}

print_section() {
  echo -e "${BLUE}\n--------------------------------------------------------------------"
  echo -e "$1"
  echo -e "--------------------------------------------------------------------${NC}"
}

print_success() {
  echo -e "${GREEN}✅ Success: $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠️ Warning: $1${NC}"
}

print_error() {
  echo -e "${RED}❎ Error: $1${NC}"
}

# Unified installation check
is_installed() {
  local identifier=$1

  # First check if command exists
  command -v "$identifier" >/dev/null 2>&1 && return 0

  # Then check if package is installed (only for pacman packages)
  if pacman -Qs "$identifier" >/dev/null 2>&1; then
    return 0
  fi

  return 1
}

install_or_skip() {
  local identifier=$1 # Can be package name or command name
  local install_cmd=$2
  local description=$3

  if is_installed "$identifier"; then
    print_warning "$description ($identifier) already installed/available. Skipping..."
    return 0
  fi

  print_section "Installing $description..."
  if eval "$install_cmd"; then
    if is_installed "$identifier"; then
      print_success "Installed $description"
      return 0
    else
      print_error "Installation succeeded but $description doesn't appear to be installed"
      return 1
    fi
  else
    print_error "Failed to install $description"
    return 1
  fi
}
