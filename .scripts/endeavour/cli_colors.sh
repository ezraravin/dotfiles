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

# Helper functions
package_installed() {
  local package=$1
  pacman -Qs "$package" >/dev/null 2>&1 || yay -Qs "$package" >/dev/null 2>&1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

install_or_skip() {
  local package=$1
  local install_cmd=$2
  local description=$3

  if ! package_installed "$package"; then
    print_section "Installing $description..."
    if eval "$install_cmd"; then
      print_success "Installed $description"
    else
      print_error "Failed to install $description"
    fi
  else
    print_warning "$package already installed. Skipping..."
  fi
}
