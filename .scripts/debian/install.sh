#!/bin/bash
# 🚀 Debian 12 Setup Script

# 🔒 Sudo Keepalive
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# Docker
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update

# 🦭 Podman & Podman Compose
sudo apt install -y make cmake git wget bat ripgrep zoxide fzf ninja-build gettext docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 🛠️ CORE SETUP
echo "🌟 Core Tools Installation"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
export PATH="$HOME/.cargo/bin:$PATH"
cargo install eza

# ✏️ EDITORS
echo "📝 Neovim Installation"
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=Release && sudo make install && cd .. && rm -rf neovim

# BLESH
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
echo 'source ~/.local/share/blesh/ble.sh' >>~/.bashrc

# 🚀 FINAL SETUP
echo "🎯 Final Touches"
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y

# 🔄 REBOOT
echo "🎉 Setup complete! Rebooting in 5 seconds..."
sleep 5
sudo reboot
