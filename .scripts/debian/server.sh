#!/bin/bash

set -e

# Auto-elevate to root
if [ "$(id -u)" -ne 0 ]; then
    exec sudo "$0" "$@"
fi

install_deps() {
    command -v avahi-daemon &>/dev/null || apt install -y avahi-daemon
    command -v nginx &>/dev/null || apt install -y nginx
}

add_avahi_host() {
    echo "$1   $2" >> /etc/avahi/hosts
    systemctl restart avahi-daemon
    echo "✅ [Avahi] $2.local → $1"
}

add_nginx_proxy() {
    local domain="$1"
    local ip="$2"  # Fix: Use IP directly
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
    if ! nginx -t; then
        echo "❌ Nginx error:"
        nginx -T | grep -A10 "server_name $domain.local"
        exit 1
    fi
    systemctl restart nginx
    echo "✅ [Nginx] http://$domain.local → $ip:$port (Verified)"
}

main() {
    install_deps
    declare -A domains
    declare -A ports

    while true; do
        clear
        echo "=== Local Domain Setup ==="
        echo "1. Add/Edit Domain"
        echo "2. Add Port Forwarding"
        echo "3. Review Configs"
        echo "4. Apply Changes"
        echo "5. Exit"
        read -p "Choose: " choice

        case "$choice" in
            1)
                read -p "Server IP: " ip
                read -p "Domain (e.g., myserver): " domain
                domains["$ip"]="${domain%.local}"
                ;;
            2)
                [ ${#domains[@]} -eq 0 ] && { echo "Add a domain first!"; sleep 1; continue; }
                select domain in "${domains[@]}"; do [ -n "$domain" ] && break; done
                read -p "Port: " port
                ports["$domain"]="$port"
                ;;
            3)
                echo "Domains:"
                for ip in "${!domains[@]}"; do echo "  - ${domains[$ip]}.local → $ip"; done
                echo "Ports:"
                for domain in "${!ports[@]}"; do echo "  - ${domain}.local → ${domains[$ip]}:${ports[$domain]}"; done
                read -p "Press Enter..."
                ;;
            4)
                > /etc/avahi/hosts
                for ip in "${!domains[@]}"; do
                    add_avahi_host "$ip" "${domains[$ip]}"
                done
                for domain in "${!ports[@]}"; do
                    add_nginx_proxy "$domain" "$ip" "${ports[$domain]}"  # Fix: Pass IP correctly
                done
                echo "🎉 Success!"
                sleep 2
                ;;
            5) exit 0 ;;
            *) echo "Invalid option!"; sleep 1 ;;
        esac
    done
}

main