echo "♦️ Ruby on Rails Setup"
# Install essential build tools and dependencies
sudo pacman -S --noconfirm base-devel libffi libyaml openssl zlib readline ncurses gmp
# These are crucial for Ruby compilation
sudo pacman -S --noconfirm libyaml openssl-1.1
curl https://mise.run | sh
gem install rails --no-document
