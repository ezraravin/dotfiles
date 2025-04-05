#!/bin/bash

# --------------------------------------
# Zero-Effort Local Domain Setup
# --------------------------------------
# Features:
#   - Auto-elevates to root if needed
#   - Interactive domain/port management
#   - Installs dependencies automatically
#   - Preview/edit before applying
# --------------------------------------

set -e

# Auto-elevate to root if not already
if [ "$(id -u)" -ne 0 ]; then
    echo "🔒 Requesting sudo permissions to continue..."
    exec sudo "$0" "$@"  # Re-launch script as root
    exit 1  # Exit if sudo fails
fi

# Install dependencies
install_deps() {
    echo "🛠️  Checking dependencies..."
    if ! command -v avahi-daemon &>/dev/null; then
        apt update -qq && apt install -y avahi-daemon
    fi
    if ! command -v nginx &>/dev/null; then
        apt install -y nginx
    fi
}

# Add domain to Avahi
add_avahi_host() {
    local ip="$1"
    local domain="$2"
    echo "$ip   $domain" >> /etc/avahi/hosts
    systemctl restart avahi-daemon
    echo "✅ [Avahi] $domain.local → $ip"
}

# Add Nginx proxy
add_nginx_proxy() {
    local domain="$1"
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

# Interactive domain input
input_domain() {
    read -p "🌐 Enter domain (e.g., 'myserver'): " domain
    domain="${domain%.local}"  # Strip .local if added
    echo "$domain"
}

# Main menu
main() {
    install_deps
    declare -A domains  # IP -> Domain map
    declare -A ports    # Domain -> Port map

    while true; do
        clear
        echo "=== 🏠 Local Domain Setup ==="
        echo "1. Add/Edit Domain"
        echo "2. Add Port Forwarding (Nginx)"
        echo "3. Review Configurations"
        echo "4. Apply Changes"
        echo "5. Exit"
        read -p "📌 Choose an option (1-5): " choice

        case "$choice" in
            1)
                read -p "🔢 Enter server IP (e.g., 192.168.1.100): " ip
                domain=$(input_domain)
                domains["$ip"]="$domain"
                ;;
            2)
                if [ ${#domains[@]} -eq 0 ]; then
                    echo "❌ No domains added yet! Use option 1 first."
                    sleep 2
                    continue
                fi
                echo "📡 Select a domain to add port forwarding:"
                select domain in "${domains[@]}"; do
                    [ -n "$domain" ] && break
                done
                read -p "🔌 Enter port (e.g., 8080): " port
                ports["$domain"]="$port"
                ;;
            3)
                echo "=== 🔍 Current Configuration ==="
                echo "📌 Domains:"
                for ip in "${!domains[@]}"; do
                    echo "  - ${domains[$ip]}.local → $ip"
                done
                echo "🔌 Port Forwarding:"
                for domain in "${!ports[@]}"; do
                    echo "  - ${domain}.local → ${domains[$ip]}:${ports[$domain]}"
                done
                read -p "📝 Press Enter to continue..."
                ;;
            4)
                echo "🚀 Applying changes..."
                > /etc/avahi/hosts  # Clear existing
                for ip in "${!domains[@]}"; do
                    add_avahi_host "$ip" "${domains[$ip]}"
                done
                for domain in "${!ports[@]}"; do
                    add_nginx_proxy "$domain" "${domains[$ip]}" "${ports[$domain]}"
                done
                echo "🎉 All changes applied!"
                sleep 2
                ;;
            5)
                echo "👋 Exiting."
                exit 0
                ;;
            *)
                echo "❌ Invalid option!"
                sleep 1
                ;;
        esac
    done
}

# Start the script
main