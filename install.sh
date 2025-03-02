#!/bin/bash
set -e

# Make scripts executable
chmod +x 00-script-environment.sh
chmod +x 01-base-setup.sh
chmod +x 02-dev-tools.sh
chmod +x 03-node-setup.sh
chmod +x 04-python-setup.sh
chmod +x 05-docker-setup.sh

# Welcome message
echo "====================================================="
echo "      Setting up your Mac"
echo "      This process will install all development tools"
echo "====================================================="
echo

# Run each script with confirmation
echo "Ready to set up your custom script environment?"
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ./00-script-environment.sh
    # Source the init script to make sure we have access to all env vars
    source ~/code/scripts/init.sh
fi

echo
echo "Ready to run the base setup? This will install Homebrew and CLI utilities."
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ./01-base-setup.sh
fi

echo
echo "Ready to install development tools (VS Code, Cursor, Ghostty, GCloud, GitHub CLI, etc.)?"
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ./02-dev-tools.sh
fi

echo
echo "Ready to set up Node.js environment with NVM?"
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ./03-node-setup.sh
fi

echo
echo "Ready to set up Python with Conda?"
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ./04-python-setup.sh
fi

echo
echo "Ready to install Docker?"
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ./05-docker-setup.sh
fi

echo
echo "====================================================="
echo "      Installation complete!"
echo "      Please restart your terminal to ensure all"
echo "      environment variables are properly loaded."
echo "====================================================="
