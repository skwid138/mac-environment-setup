#!/bin/bash
set -e

echo "Installing common applications..."

# Function to install an application using Homebrew cask
install_app_with_brew() {
    local app_name=$1
    local cask_name=$2
    local display_name=$3
    
    if [ -z "$display_name" ]; then
        display_name=$app_name
    fi
    
    echo "====================================================="
    echo "Installing $display_name"
    echo "====================================================="
    
    # Check if app is already installed in Applications folder
    if [ -d "/Applications/$app_name.app" ]; then
        echo "$display_name is already installed."
        return 0
    fi
    
    # Prompt user before installing
    read -p "Would you like to install $display_name? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping $display_name installation."
        return 0
    fi
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Please run 01-base-setup.sh first."
        return 1
    fi
    
    # Install the application
    echo "Installing $display_name using Homebrew..."
    if ! brew list --cask $cask_name &>/dev/null; then
        brew install --cask $cask_name
        echo "$display_name has been installed successfully."
    else
        echo "$display_name is already installed via Homebrew."
    fi
    
    echo
}

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Please run 01-base-setup.sh first."
    exit 1
fi

# Web Browsers
echo "====================================================="
echo "Web Browsers"
echo "====================================================="

# Firefox
install_app_with_brew "Firefox" "firefox" "Mozilla Firefox"

# Google Chrome
install_app_with_brew "Google Chrome" "google-chrome" "Google Chrome"

# Communication Tools
echo "====================================================="
echo "Communication Tools"
echo "====================================================="

# Slack
install_app_with_brew "Slack" "slack" "Slack"

# Discord
install_app_with_brew "Discord" "discord" "Discord"

# Final message
echo "====================================================="
echo "Common applications installation complete!"
echo "====================================================="
