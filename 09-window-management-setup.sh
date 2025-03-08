#!/bin/bash
set -e

echo "Setting up window management tools..."

# Install Rectangle if not already installed
if ! brew list --cask rectangle &>/dev/null; then
    echo "Installing Rectangle for window management..."
    read -p "Would you like to install Rectangle for window management? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        brew install --cask rectangle
        
        echo "Rectangle installed. You can configure it by launching the app."
        echo "For a quick start, consider using Spectacle-like shortcuts:"
        echo "  - Open Rectangle preferences"
        echo "  - Go to the 'Shortcuts' tab"
        echo "  - Select 'Spectacle' from the preset dropdown"
    else
        echo "Skipping Rectangle installation."
    fi
else
    echo "Rectangle is already installed."
fi

echo "Window management tools setup complete!"
