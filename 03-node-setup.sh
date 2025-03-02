#!/bin/bash
set -e

echo "Setting up Node.js environment with NVM..."

# Install NVM for Node version management
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Update nvm.sh with proper configuration
cat > ~/code/scripts/nvm.sh << 'EOF'
#!/bin/bash

# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF

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

echo "Node.js environment set up complete!"

