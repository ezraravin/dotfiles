# Dev Environment
echo "💻 Dev Setup"
sudo pacman -S --noconfirm nodejs npm python yarn pnpm lazygit docker docker-compose visidata code
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
yay -S --noconfirm lazydocker cloudflare-warp-bin marp-cli google-chrome
sudo systemctl start warp-svc
sudo systemctl enable warp-svc
yes | warp-cli registration new
/bin/bash -c "$(curl -fsSL https://php.new/install/linux)"
curl -fsSL https://bun.sh/install | bash
echo "✅ Dev tools installed"
