#!/bin/bash
set -e

DEPLOY_DIR="/opt/prosodylabs.com.au"
REPO_URL="ssh://github-personal/prosodylabs/prosodylabs.com.au.git"
SERVICE_NAME="waitlist-api"

echo "🚀 Deploying Prosody Labs Waitlist API..."

# Check if this is an update or fresh install
IS_UPDATE=false
if [ -d "$DEPLOY_DIR/.git" ]; then
    IS_UPDATE=true
    echo "📦 Updating existing installation..."
else
    echo "🆕 Fresh installation..."
fi

# Create deployment directory
sudo mkdir -p $DEPLOY_DIR
sudo chown $USER:$USER $DEPLOY_DIR

# Clone or update repository
if [ "$IS_UPDATE" = true ]; then
    cd $DEPLOY_DIR
    echo "📥 Pulling latest changes..."
    
    # Reset any local changes and pull latest
    echo "🔄 Resetting to clean state..."
    git reset --hard HEAD
    # Clean untracked files, ignoring permission errors
    git clean -fd || true
    echo "✅ Local changes discarded"
    
    # Pull latest changes
    git pull origin main
    echo "✅ Repository updated"
else
    echo "📥 Cloning repository..."
    git clone $REPO_URL $DEPLOY_DIR
    echo "✅ Repository cloned"
fi

# Navigate to backend directory
cd $DEPLOY_DIR/backend

# Stop service if it's running (for updates)
if [ "$IS_UPDATE" = true ] && systemctl is-active --quiet $SERVICE_NAME; then
    echo "⏸️  Stopping service for update..."
    sudo systemctl stop $SERVICE_NAME
fi

# Install/update dependencies
echo "📦 Installing dependencies..."
npm ci --only=production
echo "✅ Dependencies installed"

# Create and configure data directory with proper permissions
echo "📁 Configuring data directory permissions..."
sudo mkdir -p $DEPLOY_DIR/backend/data
sudo chown -R www-data:www-data $DEPLOY_DIR/backend/data
sudo chmod -R 755 $DEPLOY_DIR/backend/data
echo "✅ Data directory permissions configured"

# Setup environment (only for fresh installs)
if [ ! -f .env ]; then
    echo "⚙️  Setting up environment file..."
    cp env.example .env
    echo "⚠️  Please edit .env with your configuration before starting the service"
    echo "   File location: $DEPLOY_DIR/backend/.env"
    if [ "$IS_UPDATE" = false ]; then
        exit 1
    fi
fi

# Setup systemd service
echo "🔧 Configuring systemd service..."
sudo cp waitlist-api.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME

# Start or restart service
if [ "$IS_UPDATE" = true ]; then
    echo "🔄 Restarting service..."
    sudo systemctl restart $SERVICE_NAME
else
    echo "▶️  Starting service..."
    sudo systemctl start $SERVICE_NAME
fi

# Wait a moment for service to start
sleep 2

# Check service status
if systemctl is-active --quiet $SERVICE_NAME; then
    echo "✅ Service is running successfully!"
else
    echo "❌ Service failed to start. Check logs with: sudo journalctl -u $SERVICE_NAME -f"
    exit 1
fi

echo ""
echo "🎉 Deployment complete!"
echo "📊 Service status: sudo systemctl status $SERVICE_NAME"
echo "📋 Service logs: sudo journalctl -u $SERVICE_NAME -f"
echo "🌐 Health check: curl https://api.prosodylabs.com.au/api/health"
