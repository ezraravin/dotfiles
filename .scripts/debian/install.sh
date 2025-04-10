#!/bin/bash
# 🚀 Debian 12 Setup Script

# 🔒 Sudo Keepalive
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# 🔧 Utility Functions
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# 🦭 Podman
sudo apt install podman

# 🛠️ CORE SETUP
echo "🌟 Core Tools Installation"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
export PATH="$HOME/.cargo/bin:$PATH"
sudo apt install -y golang cmake git curl bat ripgrep
go install github.com/jesseduffield/lazydocker@latest
cargo install eza

# 🐚 SHELL SETUP
echo "🐚 Zsh & Tools"
sudo apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions zoxide fzf
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# ✏️ EDITORS
echo "📝 Neovim Installation"
sudo apt install -y ninja-build gettext
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=Release && sudo make install && cd .. && rm -rf neovim

# 🚀 FINAL SETUP
echo "🎯 Final Touches"
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
sudo chsh -s $(which zsh) $USER

echo "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >>.zshrc
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>.zshrc

# 🔄 REBOOT
echo "🎉 Setup complete! Rebooting in 5 seconds..."
sleep 5
sudo reboot
