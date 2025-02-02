# Make Keygen
ssh-keygen -t ed25519 -C "ezraravin.m@gmail.com"

# PopOS

```bash
# CLONE DOTFILES
mkdir .config
git clone git@gitlab.com://gitlab.com/ezraravinmateus/dotfiles
cd dotfiles
mv .config/* ~/.config && sudo rm -rf .config
mv ./* ~/ && mv ./.* ~/ && cd ../ && rm -rf dotfiles

# INSTALL NERD FONT
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip && sudo unzip JetBrainsMono.zip -d /usr/share/fonts/truetype/

# INSTALL NVIDIA, KAZAM, CLIPBOARD
sudo apt install -y system76-driver-nvidia kazam wl-clipboard

# REMOVE BLOATWARE
sudo apt remove --purge thunderbird firefox cosmic-term

# INSTALL CALENDAR, EMAIL, GOOGLE CHROME, KDENLIVE, OBS, KITTY
sudo apt install -y gnome-calendar evolution google-chrome-stable kdenlive obs-studio kitty

# UPGRADE & UPDATE
sudo apt update --yes && sudo apt upgrade --yes

# INSTALL ZSH, FZF, RIPGREP, EZA, LUAROCKS, SNAP
sudo apt install --yes zsh fzf ripgrep eza luarocks snapd

# INSTALL NEOVIM
sudo snap install nvim --classic

# INSTALL NODEJS
sudo snap install node --classic

# INSTALL WHATSAPP
sudo snap install whatsapp-linux-app spotify

# CHANGE SHELL TO ZSH
chsh -s $(which zsh)

# INSTALL BUN, NPM
curl -fsSL https://bun.sh/install | bash
sudo apt install --yes npm

# INSTALL PHP, COMPOSER
sudo apt install --yes php composer

# INSTALL RUST, CARGO
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# INSTALL OH MY ZSH
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# INSTALL OH-MY-POSH
curl -s https://ohmyposh.dev/install.sh | bash -s

# INSTALL ZOXIDE
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# INSTALL LAZYGIT
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit && sudo install lazygit -D -t /usr/local/bin/ && sudo rm lazygit lazygit.tar.gz

# INSTALL MARP-CLI
bun install -g @marp-team/marp-cli

# INSTALL ZSH AUTOSUGGESTION, ZSH SYNTAX HIGHLIGHTING, YAZI
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/sxyazi/yazi.git && cd yazi && cargo build --release --locked && sudo mv target/release/yazi target/release/ya /usr/local/bin/ && sudo mv target/release/yazi target/release/ya /usr/local/bin/ && cd ../ && sudo rm -rf yazi

# INSTALL DAVINCI RESOLVE 
git clone https://github.com/leinardi/JDInstaller.git
cd JDInstaller && git checkout davinci && make install TAGS=davinci_resolve

# INSTALL STEAM
sudo apt install --yes steam

# INSTALL XPADNEO
git clone https://github.com/atar-axis/xpadneo.git && cd xpadneo && sudo ./install.sh && cd ../ && sudo rm -rf xpadneo
sudo systemctl reboot
```

