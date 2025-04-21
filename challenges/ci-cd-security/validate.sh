#!/bin/bash

# CI/CD Security Challenge Environment Validation Script

echo "🔍 Validating CI/CD Security Challenge Environment..."

# Check Docker
echo "Checking Docker installation..."
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi
echo "✅ Docker is installed"

# Check Docker Compose
echo "Checking Docker Compose installation..."
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi
echo "✅ Docker Compose is installed"

# Check if Docker is running
echo "Checking if Docker is running..."
if ! docker info &> /dev/null; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi
echo "✅ Docker is running"

# Check port 8080 availability
echo "Checking port 8080 availability..."
if lsof -i :8080 &> /dev/null; then
    echo "❌ Port 8080 is already in use. Please free up port 8080."
    exit 1
fi
echo "✅ Port 8080 is available"

# Check required files
echo "Checking required files..."
required_files=("Dockerfile" "docker-compose.yml" "jenkins.yaml" "WALKTHROUGH.md" "SETUP.md")
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Required file $file is missing."
        exit 1
    fi
    echo "✅ $file exists"
done

# Check Docker image build
echo "Building Docker image..."
if ! docker-compose build challenge-env; then
    echo "❌ Failed to build Docker image."
    exit 1
fi
echo "✅ Docker image built successfully"

# Start the container
echo "Starting Jenkins container..."
if ! docker-compose up -d challenge-env; then
    echo "❌ Failed to start Jenkins container."
    exit 1
fi
echo "✅ Jenkins container started"

# Wait for Jenkins to be ready
echo "Waiting for Jenkins to be ready..."
sleep 30

# Check if Jenkins is accessible
echo "Checking Jenkins accessibility..."
if ! curl -s http://localhost:8080/login > /dev/null; then
    echo "❌ Jenkins is not accessible. Please check the container logs."
    exit 1
fi
echo "✅ Jenkins is accessible"

echo "🎉 Environment validation completed successfully!"
echo "You can now proceed with the challenge by following the WALKTHROUGH.md guide." 