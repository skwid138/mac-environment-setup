#!/bin/bash
set -e

echo "Setting up base development environment..."

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for the current session
    eval "$(/opt/homebrew/bin/brew shellenv)"

    echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/code/scripts/paths.sh
else
    echo "Homebrew already installed, updating..."
    brew update
fi

# Install CLI utilities
echo "Installing fun CLI utilities..."
brew install fortune cowsay lolcat tmux

echo "Base setup complete!"

