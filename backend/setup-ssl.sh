#!/bin/bash
set -e

echo "Setting up SSL certificates for api.prosodylabs.com.au..."

# Install dependencies
sudo apt-get update
sudo apt-get install -y nginx certbot python3-certbot-nginx

# Copy nginx config (HTTP-only version for initial setup)
sudo cp nginx/nginx-initial.conf /etc/nginx/sites-available/api.prosodylabs.com.au
sudo ln -sf /etc/nginx/sites-available/api.prosodylabs.com.au /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Obtain certificate using nginx plugin (automatically configures nginx)
sudo certbot --nginx \
    -d api.prosodylabs.com.au \
    --email info@prosodylabs.com.au \
    --agree-tos \
    --no-eff-email \
    --redirect

# Setup auto-renewal
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer

echo "SSL setup complete!"
echo "Certificate will auto-renew via systemd timer"
echo "Nginx has been automatically configured with SSL"
