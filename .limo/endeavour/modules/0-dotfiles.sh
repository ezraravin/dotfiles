# Git SSH Setup
echo "Git Setup"
# Dotfiles
[ ! -d ~/dotfiles ] && git clone https://github.com/ezraravin/dotfiles.git ~/dotfiles &&
  cp -r ~/dotfiles/. ~/ && rm -rf ~/dotfiles

# Git Config
if ! git config --global user.email &>/dev/null; then
  git config --global user.email "ezraravin@proton.me"
  git config --global user.name "Rave"
  git config --global init.defaultBranch main
fi
