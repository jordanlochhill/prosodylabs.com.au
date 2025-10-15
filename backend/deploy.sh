#!/bin/bash
set -e

DEPLOY_DIR="/opt/prosodylabs/backend"
REPO_URL="ssh://github-personal/prosodylabs/prosodylabs.git"

echo "Deploying Prosody Labs Waitlist API..."

# Create deployment directory
sudo mkdir -p $DEPLOY_DIR
sudo chown $USER:$USER $DEPLOY_DIR

# Clone or update repository
if [ -d "$DEPLOY_DIR/.git" ]; then
    cd $DEPLOY_DIR
    git pull origin main
else
    git clone $REPO_URL $DEPLOY_DIR
    cd $DEPLOY_DIR/prosodylabs.com.au/backend
fi

# Install dependencies
npm ci --only=production

# Setup environment
if [ ! -f .env ]; then
    cp env.example .env
    echo "Please edit .env with your configuration"
    exit 1
fi

# Setup systemd service
sudo cp waitlist-api.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable waitlist-api
sudo systemctl restart waitlist-api

echo "Deployment complete!"
echo "Check status: sudo systemctl status waitlist-api"
