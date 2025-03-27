#!/bin/bash
# setup_ai.sh - AI Development Environment Setup
# Description:
#   Installs and configures AI development tools including:
#   - Ollama (local LLM framework)
#   - Chatbox (GUI chat interface)
#   - Pre-downloads common AI models
# Notes:
#   Requires yay for AUR packages
#   Internet connection needed for model downloads

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

install_ollama() {
  print_section "🦙 Installing Ollama"
  install_or_skip "ollama" "curl -fsSL https://ollama.com/install.sh | sh" "Ollama LLM Framework"
}

install_chatbox() {
  print_section "💬 Installing Chatbox"
  install_or_skip "chatbox" "yay -S --noconfirm chatbox-bin" "Chatbox GUI"
}

download_models() {
  print_section "📥 Downloading AI Models"
  local models=(
    "deepseek-coder" # DeepSeek's Programming-focused model
    "deepseek-v3"    # DeepSeek's general-purpose model
    "deepseek-r1"    # DeepSeek's reasoning model
    "qwen2.5"        # Alibaba's multilingual model
  )

  for model in "${models[@]}"; do
    print_section "  Downloading $model"
    if ollama pull "$model"; then
      print_success "Model downloaded: $model"
    else
      print_error "Failed to download: $model"
    fi
  done
}

main() {
  print_header "🤖 AI Development Setup"

  # Core installations
  install_ollama
  install_chatbox

  # Model setup if Ollama installed
  if command_exists ollama; then
    download_models
  else
    print_warning "Ollama not found - skipping model downloads"
  fi

  print_success "AI tools configured"
  echo -e "${YELLOW}Usage:"
  echo "  Start Chatbox: chatbox"
  echo "  Run Ollama: ollama run [model-name]${NC}"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
