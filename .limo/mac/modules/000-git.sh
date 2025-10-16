git config --global user.email "ezraravin@proton.me"
git config --global user.name "MacBook Air M1"
git config --global init.defaultBranch main
[ ! -d ~/dotfiles ] && git clone https://github.com/ezraravin/dotfiles.git ~/dotfiles &&
  cp -r ~/dotfiles/. ~/ && rm -rf ~/dotfiles