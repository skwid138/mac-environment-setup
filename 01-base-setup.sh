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
echo "Installing CLI utilities..."
if ! brew list fortune &>/dev/null; then
    brew install fortune
else
    echo "fortune is already installed."
fi

if ! brew list cowsay &>/dev/null; then
    brew install cowsay
else
    echo "cowsay is already installed."
fi

if ! brew list lolcat &>/dev/null; then
    brew install lolcat
else
    echo "lolcat is already installed."
fi

if ! brew list tmux &>/dev/null; then
    brew install tmux
else
    echo "tmux is already installed."
fi


echo "Base setup complete!"

