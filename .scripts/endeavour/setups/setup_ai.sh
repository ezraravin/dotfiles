#!/bin/bash
# setup_ai.sh - AI tools installation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/cli_colors.sh"

install_ollama() {
  install_or_skip "ollama" "curl -fsSL https://ollama.com/install.sh | sh" "Ollama"
}

install_chatbox() {
  install_or_skip "chatbox" "yay -S --noconfirm chatbox-bin" "Chatbox"
}

pull_models() {
  local models=(
    "deepseek-r1" "qwen2.5" "qwen2.5-coder"
    "deepseek-coder-v2" "deepseek-llm" "deepseek-v2"
  )

  for model in "${models[@]}"; do
    print_section "Pulling $model"
    ollama pull "$model" && print_success "Pulled $model" || print_error "Failed to pull $model"
  done
}

main() {
  print_header "🤖 Setting Up AI Tools"

  install_ollama
  install_chatbox

  if command_exists ollama; then
    pull_models
  else
    print_error "Ollama not installed - skipping model downloads"
  fi
}

# Run if executed directly
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main

#
#
#

#!/bin/bash
# setup_ai.sh - AI Tools

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "$SCRIPT_DIR/../cli_colors.sh"

setup_ai() {
  print_header "🤖 AI Tools"

  install_or_skip "ollama" "curl -fsSL https://ollama.com/install.sh | sh" "Ollama"
  install_or_skip "chatbox" "yay -S --noconfirm chatbox-bin" "Chatbox"

  if command_exists ollama; then
    print_section "Pulling Models"
    local models=("deepseek-coder" "llama3")
    for model in "${models[@]}"; do
      ollama pull $model
    done
  fi

  print_success "AI tools ready"
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && setup_ai
