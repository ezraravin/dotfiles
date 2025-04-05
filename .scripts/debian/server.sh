#!/bin/bash

# --------------------------------------
# Local Domain + Subdomain Setup (Debian 12)
# --------------------------------------
# Features:
#   - Auto-elevate to root
#   - Add main domains (e.g., rodeon33.local)
#   - Add subdomains (e.g., sub.rodeon33.local)
#   - Port forwarding via Nginx
#   - Disable Apache if conflicting
# --------------------------------------

set -e

# Auto-elevate to root
if [ "$(id -u)" -ne 0 ]; then
    exec sudo "$0" "$@"
fi

# Stop Apache if running (free port 80)
if systemctl is-active --quiet apache2; then
    echo "🚀 Stopping Apache to free port 80..."
    systemctl stop apache2
    systemctl disable apache2
fi

# Install dependencies
install_deps() {
    command -v avahi-daemon &>/dev/null || apt install -y avahi-daemon
    command -v nginx &>/dev/null || apt install -y nginx
}

# Add Avahi host (for .local resolution)
add_avahi_host() {
    local ip="$1"
    local domain="$2"
    echo "$ip   $domain" >> /etc/avahi/hosts
    systemctl restart avahi-daemon
    echo "✅ [Avahi] $domain → $ip"
}

# Add Nginx proxy (supports subdomains)
add_nginx_proxy() {
    local domain="$1"    # e.g., "sub.rodeon33" or "rodeon33"
    local ip="$2"
    local port="$3"
    local config_file="/etc/nginx/sites-available/$domain"

    cat > "$config_file" <<EOF
server {
    listen 80;
    server_name $domain.local;
    location / {
        proxy_pass http://$ip:$port;
        proxy_set_header Host \$host;
    }
}
EOF

    ln -sf "$config_file" "/etc/nginx/sites-enabled/"
    nginx -t && systemctl restart nginx
    echo "✅ [Nginx] http://$domain.local → $ip:$port"
}

# Interactive menu
main() {
    install_deps
    declare -A domains  # IP -> Domain map
    declare -A ports    # Domain -> Port map

    while true; do
        clear
        echo "=== Local Domain/Subdomain Setup ==="
        echo "1. Add Main Domain (e.g., rodeon33)"
        echo "2. Add Subdomain (e.g., sub.rodeon33)"
        echo "3. Add Port Forwarding"
        echo "4. Review Configs"
        echo "5. Apply Changes"
        echo "6. Exit"
        read -p "Choose (1-6): " choice

        case "$choice" in
            1)
                read -p "Server IP (e.g., 192.168.1.4): " ip
                read -p "Main Domain (e.g., rodeon33): " domain
                domains["$ip"]="$domain"
                ;;
            2)
                if [ ${#domains[@]} -eq 0 ]; then
                    echo "Add a main domain first!"
                    sleep 1
                    continue
                fi
                read -p "Subdomain (e.g., 'sub' for sub.rodeon33): " sub
                read -p "Main Domain to attach to: " main_domain
                domains["$ip"]="$sub.$main_domain"  # e.g., sub.rodeon33
                ;;
            3)
                echo "Select a domain:"
                select domain in "${domains[@]}"; do
                    [ -n "$domain" ] && break
                done
                read -p "Port (e.g., 8080): " port
                ports["$domain"]="$port"
                ;;
            4)
                echo "=== Current Config ==="
                for ip in "${!domains[@]}"; do
                    echo "  - ${domains[$ip]}.local → $ip"
                done
                for domain in "${!ports[@]}"; do
                    echo "  - ${domain}.local → ${domains[$ip]}:${ports[$domain]}"
                done
                read -p "Press Enter..."
                ;;
            5)
                > /etc/avahi/hosts  # Clear old entries
                for ip in "${!domains[@]}"; do
                    add_avahi_host "$ip" "${domains[$ip]}"
                done
                for domain in "${!ports[@]}"; do
                    add_nginx_proxy "$domain" "$ip" "${ports[$domain]}"
                done
                echo "🎉 Done! Test with:"
                for domain in "${!domains[@]}"; do
                    echo "  - ping ${domains[$domain]}.local"
                    echo "  - curl http://${domains[$domain]}.local"
                done
                sleep 3
                ;;
            6) exit 0 ;;
            *) echo "Invalid option!"; sleep 1 ;;
        esac
    done
}

main