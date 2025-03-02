#!/bin/bash
set -e

echo "Installing Docker environment..."

# Install Docker Desktop (includes Docker, Docker Compose, and Docker Desktop)
brew install --cask docker

echo "Docker installation complete! Please launch Docker Desktop manually to complete setup."

