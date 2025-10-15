#!/bin/bash

# Development server script for Prosody Labs website
# This runs both the backend API and frontend Jekyll server

set -e

echo "🚀 Starting Prosody Labs development environment..."
echo "📝 Using development configuration overrides"
echo "🌐 Frontend will be available at: http://localhost:4000"
echo "🔗 Backend API will be available at: http://localhost:3001"
echo ""

# Function to cleanup background processes
cleanup() {
    echo ""
    echo "🛑 Shutting down development servers..."
    if [ ! -z "$JEKYLL_PID" ]; then
        kill $JEKYLL_PID 2>/dev/null || true
        echo "✅ Jekyll server stopped"
    fi
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null || true
        echo "✅ Backend API server stopped"
    else
        echo "ℹ️  Backend API was already running (not stopped)"
    fi
    echo "✅ Development environment shutdown complete"
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Check if backend dependencies are installed
if [ ! -d "backend/node_modules" ]; then
    echo "📦 Installing backend dependencies..."
    cd backend
    npm install
    cd ..
    echo "✅ Backend dependencies installed"
fi

# Check if Jekyll dependencies are installed
if [ ! -d "_site" ] && [ ! -f "Gemfile.lock" ]; then
    echo "📦 Installing Jekyll dependencies..."
    bundle install
    echo "✅ Jekyll dependencies installed"
fi

# Check if backend is already running
if curl -s http://localhost:3001/api/health > /dev/null; then
    echo "✅ Backend API is already running at http://localhost:3001"
    BACKEND_PID=""
else
    # Start backend API server
    echo "🔧 Starting backend API server..."
    cd backend
    npm start &
    BACKEND_PID=$!
    cd ..

    # Wait a moment for backend to start
    sleep 3

    # Check if backend started successfully
    if ! curl -s http://localhost:3001/api/health > /dev/null; then
        echo "❌ Backend API failed to start. Check the logs above."
        cleanup
    fi

    echo "✅ Backend API started successfully at http://localhost:3001"
fi

# Start Jekyll development server
echo "🌐 Starting Jekyll development server..."
bundle exec jekyll serve --config _config.yml,_config_dev.yml --livereload --drafts &
JEKYLL_PID=$!

# Wait a moment for Jekyll to start
sleep 3

echo ""
echo "🎉 Development environment is ready!"
echo "🌐 Frontend: http://localhost:4000"
echo "🔗 Backend API: http://localhost:3001"
echo "📋 API Health: http://localhost:3001/api/health"
echo ""
echo "Press Ctrl+C to stop both servers"
echo ""

# Wait for user to stop
wait
