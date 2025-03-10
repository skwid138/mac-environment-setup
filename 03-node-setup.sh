#!/bin/bash
set -e

echo "====================================================="
echo "Setting up Node.js environment with NVM..."
echo "====================================================="

# Install NVM for Node version management
if ! command -v nvm &> /dev/null; then
    # Could use brew to install nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
else
    echo "NVM is already installed."
fi

# Update nvm.sh with proper configuration
if [ ! -f ~/code/scripts/nvm.sh ] || ! grep -q "NVM Configuration" ~/code/scripts/nvm.sh; then
    cat > ~/code/scripts/nvm.sh << 'EOF'
#!/bin/bash

# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF
else
    echo "NVM configuration already exists."
fi

# Source NVM for current session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install latest LTS version of Node
echo "Installing latest Node.js LTS version..."
nvm install --lts

# Set LTS as default
nvm alias default 'lts/*'

# Install only essential global packages following best practices
echo "Installing minimal set of global npm packages..."
npm install -g npm-check-updates

echo "====================================================="
echo "Node.js environment set up complete!"
echo "====================================================="

