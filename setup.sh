#!/bin/bash

# Exit on any error
set -e

echo "Setting up the environment..."

# Create required directories
mkdir -p nginx/ssl

# Generate self-signed SSL certificate
echo "Generating SSL certificate..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout nginx/ssl/server.key \
    -out nginx/ssl/server.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=myapp.local"

# Create nginx configuration
echo "Creating nginx configuration..."
cat > nginx.conf << 'EOF'
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

# Remove existing entry for myapp.local if it exists
echo "Updating /etc/hosts..."
sudo sed -i '' '/myapp.local/d' /etc/hosts 2>/dev/null || true

# Add new entry for myapp.local
echo "Adding myapp.local to /etc/hosts..."
echo "127.0.0.1 myapp.local" | sudo tee -a /etc/hosts

# Flush DNS cache
echo "Flushing DNS cache..."
if [ "$(uname)" == "Darwin" ]; then
    # macOS
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
elif [ "$(uname)" == "Linux" ]; then
    # Linux
    sudo systemd-resolve --flush-caches 2>/dev/null || true
    sudo service network-manager restart 2>/dev/null || true
fi

# Clean up any existing containers and network
echo "Cleaning up existing resources..."
terraform destroy -auto-approve || true
docker network rm app_network || true

# Initialize and apply Terraform configuration
echo "Initializing Terraform..."
terraform init

echo "Applying Terraform configuration..."
terraform apply -auto-approve

# Wait for containers to be fully up
echo "Waiting for containers to start..."
sleep 10

# Get container IPs
APP_IP=$(terraform output -raw app_container_ip)
NGINX_IP=$(terraform output -raw nginx_container_ip)

echo "App container IP: ${APP_IP}"
echo "Nginx container IP: ${NGINX_IP}"

# Test DNS resolution
echo "Testing DNS resolution..."
ping -c 1 myapp.local || echo "DNS resolution test completed"

# Test containers from within the network
echo "Testing app container directly..."
docker exec nginx_lb curl -v "http://app_server:8080" || echo "Failed to connect to app container"

echo "Testing nginx proxy..."
curl -k -v "https://localhost" || echo "Failed to connect via HTTPS"
curl -k -v "https://myapp.local" || echo "Failed to connect via myapp.local"

echo "Setup complete! Access the application at https://myapp.local"
echo "Note: You might need to accept the self-signed certificate in your browser"

# Display DNS and network information
echo "DNS Resolution Information:"
echo "Contents of /etc/hosts:"
cat /etc/hosts | grep myapp
echo "Ping test to myapp.local:"
ping -c 1 myapp.local || true
echo "DNS lookup for myapp.local:"
dig myapp.local || true
nslookup myapp.local || true

# Display container logs
echo "App container logs:"
docker logs app_server

echo "Nginx container logs:"
docker logs nginx_lb

# Show network information
echo "Network information:"
docker network inspect app_network