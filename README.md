```bash
# MAKE KEYGEN
ssh-keygen -t ed25519 -C "ezraravin.m@gmail.com"

# CLONE DOTFILES
mkdir .config
git clone git@gitlab.com://gitlab.com/ezraravinmateus/dotfiles
cd dotfiles
mv .config/* ~/.config && sudo rm -rf .config
mv ./* ~/ && mv ./.* ~/ && cd ../ && rm -rf dotfiles

# INSTALL ZSH, FZF, RIPGREP, EZA, LUAROCKS, SNAP
sudo apt install --yes zsh fzf ripgrep eza luarocks snapd

# INSTALL FLUTTER
sudo snap install flutter --classic

# INSTALL WHATSAPP
sudo snap install whatsapp-linux-app

# INSTALL RUST, CARGO
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# INSTALL LAZYGIT
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit && sudo install lazygit -D -t /usr/local/bin/ && sudo rm lazygit lazygit.tar.gz

# INSTALL STEAM
sudo apt install --yes steam

# INSTALL XPADNEO
git clone https://github.com/atar-axis/xpadneo.git && cd xpadneo && sudo ./install.sh && cd ../ && sudo rm -rf xpadneo

sudo systemctl reboot
```
