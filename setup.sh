#!/bin/bash
set -e

# Check if running as root and get current user
CURRENT_USER=$(whoami)
if [ "$EUID" -eq 0 ]; then
    # If root, switch back to the original user
    SUDO_USER=$(logname || echo $CURRENT_USER)
    CURRENT_USER=$SUDO_USER
fi

# Create directories
sudo -u $CURRENT_USER mkdir -p nginx/ssl app

# Generate SSL certificate
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout nginx/ssl/server.key \
    -out nginx/ssl/server.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=myapp.local"

# Fix permissions
sudo chown -R $CURRENT_USER:$(id -gn $CURRENT_USER) nginx
sudo chown -R $CURRENT_USER:$(id -gn $CURRENT_USER) app

# Create nginx configuration
sudo -u $CURRENT_USER cat > nginx/nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /dev/stdout  main;
    error_log   /dev/stderr  debug;

    upstream backend {
        server app_server:8080;
    }

    server {
        listen 80 default_server;
        listen [::]:80 default_server;
        server_name myapp.local localhost;
        return 301 https://$host$request_uri;
    }

    server {
        listen 443 ssl default_server;
        listen [::]:443 ssl default_server;
        server_name myapp.local localhost;

        ssl_certificate /etc/nginx/ssl/server.crt;
        ssl_certificate_key /etc/nginx/ssl/server.key;
        
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers HIGH:!aNULL:!MD5;

        location / {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
EOF

# Update hosts
sudo sed -i.bak '/myapp.local/d' /etc/hosts
echo "127.0.0.1 myapp.local" | sudo tee -a /etc/hosts

# Run terraform as current user
sudo -u $CURRENT_USER terraform init -upgrade
sudo -u $CURRENT_USER terraform apply -auto-approve

# Show status
sleep 10
docker ps
docker logs app_server
docker logs nginx_lb

echo "Setup complete - Access at https://myapp.local"