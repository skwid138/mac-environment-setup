#!/bin/bash
set -e

echo "====================================================="
echo "Installing Docker environment..."
echo "====================================================="
# Install Docker Desktop (includes Docker, Docker Compose, and Docker Desktop)
if ! brew list --cask docker &>/dev/null; then
    brew install --cask docker
else
    echo "Docker is already installed."
fi

echo "====================================================="
echo "Docker installation complete! Please launch Docker Desktop manually to complete setup."
echo "====================================================="
