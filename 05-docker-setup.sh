#!/bin/bash
set -e

echo "Installing Docker environment..."

# Install Docker Desktop (includes Docker, Docker Compose, and Docker Desktop)
if ! brew list --cask docker &>/dev/null; then
    brew install --cask docker
else
    echo "Docker is already installed."
fi

echo "Docker installation complete! Please launch Docker Desktop manually to complete setup."

