# MAKE KEYGEN

ssh-keygen -t ed25519 -C "ezraravin.m@gmail.com"

# REMOVE BLOATWARE

sudo dnf remove -y ptyxis mediawriter totem yelp firefox libreoffice-impress libreoffice-calc libreoffice-writer snapshot snapshot gnome-contacts gnome-weather gnome-clocks gnome-maps gnome-calculatr gnome-boxes gnome-characters gnome-tour gnome-text-editor gnome-software gnome-abrt

# INSTALL HOMEBREW

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# INSTALL NEOVIM, HYPRLAND, GOOGLE CHROME, KITTY, TMUX, KDENLIVE, OBS, ZSH, PHP, COMPOSER, WL CLIPBOARD

sudo dnf install -y neovim hyprland google-chrome-stable kitty tmux kdenlive obs-studio zsh php composer wl-clipboard

# INSTALL ZOXIDE

curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# INSTALL OH-MY-POSH

curl -s https://ohmyposh.dev/install.sh | bash -s

# INSTALL BUN

curl -fsSL https://bun.sh/install | bash

# CHANGE SHELL TO ZSH

chsh -s $(which zsh)

# INSTALL SPOTIFY

flatpak install -y flathub com.spotify.Client

# INSTALL JETBRAINS NERD FONT

# INSTALL ZSH AUTOSUGGESTION

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# INSTALL SYNTAX HIGHLIGHTING

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
