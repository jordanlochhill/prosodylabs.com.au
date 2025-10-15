#!/bin/bash
set -e

echo "Setting up SSL certificates for api.prosodylabs.com.au..."

# Install dependencies
sudo apt-get update
sudo apt-get install -y nginx certbot python3-certbot-nginx

# Create certbot webroot
sudo mkdir -p /var/www/certbot

# Copy nginx config (initial HTTP-only version for certbot)
sudo cp nginx/nginx-initial.conf /etc/nginx/sites-available/api.prosodylabs.com.au
sudo ln -sf /etc/nginx/sites-available/api.prosodylabs.com.au /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Obtain certificate
sudo certbot certonly --webroot \
    -w /var/www/certbot \
    -d api.prosodylabs.com.au \
    --email info@prosodylabs.com.au \
    --agree-tos \
    --no-eff-email

# Copy full nginx config with SSL
sudo cp nginx/nginx.conf /etc/nginx/sites-available/api.prosodylabs.com.au
sudo nginx -t
sudo systemctl reload nginx

# Setup auto-renewal
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer

echo "SSL setup complete!"
echo "Certificate will auto-renew via systemd timer"
