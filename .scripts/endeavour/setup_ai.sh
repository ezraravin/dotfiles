#!/bin/bash
# setup_ai.sh - AI tools installation script

# Source the colors script from the same directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$DIR/cli_colors.sh"

install_ai_tools() {
  print_header "🤖 Installing AI Tools..."

  install_or_skip "ollama" 'curl -fsSL https://ollama.com/install.sh | sh' "Installing Ollama"
  install_or_skip "chatbox" 'yay -S chatbox-bin' "Installing Chatbox"

  if command_exists ollama; then
    pull_ollama_models
  else
    print_error "Ollama not found. Skipping model pull."
  fi
}

pull_ollama_models() {
  print_header "📥 Pulling Ollama Models..."
  local models=("deepseek-r1" "qwen2.5" "qwen2.5-coder" "deepseek-coder-v2" "deepseek-llm" "deepseek-v2")

  for model in "${models[@]}"; do
    print_section "  ↳ Pulling $model..."
    if ollama pull "$model"; then
      print_success "Successfully pulled $model."
    else
      print_error "Failed to pull $model."
    fi
  done
}

# Call the function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_ai_tools
fi
