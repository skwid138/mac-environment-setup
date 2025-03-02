#!/bin/bash
set -e

echo "Installing development tools..."

# Install VS Code
echo "Installing VS Code..."
brew install --cask visual-studio-code

# Install Cursor IDE
echo "Installing Cursor IDE..."
brew install --cask cursor

# Install Ghostty terminal
echo "Installing Ghostty terminal..."
brew install --cask ghostty

# Install FFmpeg for media handling
echo "Installing FFmpeg..."
brew install ffmpeg

# Install GitHub CLI
echo "Installing GitHub CLI..."
brew install gh

# Setup GitHub CLI authentication
echo "Setting up GitHub CLI..."
read -p "Would you like to authenticate with GitHub now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    gh auth login
fi

# Install GCloud CLI
echo "Installing Google Cloud SDK..."
brew install --cask google-cloud-sdk

# Add Google Cloud SDK configuration to gcloud.sh
cat > ~/code/scripts/gcloud.sh << 'EOF'
#!/bin/bash

# Google Cloud SDK configuration
if [ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]; then
    source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
    source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
fi
EOF

echo "Development tools installation complete!"
