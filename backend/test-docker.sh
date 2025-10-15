#!/bin/bash

# Test script for Docker deployment
echo "🐳 Testing Docker setup for Prosody Labs Waitlist API..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop and try again."
    exit 1
fi

echo "✅ Docker is running"

# Build the image
echo "🔨 Building Docker image..."
if docker build -t prosodylabs-waitlist-api .; then
    echo "✅ Docker image built successfully"
else
    echo "❌ Failed to build Docker image"
    exit 1
fi

# Test the container
echo "🚀 Testing container startup..."
if docker run --rm -d --name test-waitlist-api -p 3002:3001 prosodylabs-waitlist-api; then
    echo "✅ Container started successfully"
    
    # Wait for container to be ready
    echo "⏳ Waiting for container to be ready..."
    sleep 5
    
    # Test health endpoint
    if curl -s http://localhost:3002/api/health > /dev/null; then
        echo "✅ Health check passed"
    else
        echo "❌ Health check failed"
    fi
    
    # Clean up
    echo "🧹 Cleaning up test container..."
    docker stop test-waitlist-api > /dev/null 2>&1
else
    echo "❌ Failed to start container"
    exit 1
fi

echo "🎉 Docker setup test completed successfully!"
echo ""
echo "To deploy with docker-compose:"
echo "  docker-compose up -d"
echo ""
echo "To view logs:"
echo "  docker-compose logs -f waitlist-api"
