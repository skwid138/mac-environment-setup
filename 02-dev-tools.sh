#!/bin/bash
set -e

echo "Installing development tools..."

# Install VS Code if not already installed
if ! brew list --cask visual-studio-code &>/dev/null; then
    echo "Installing VS Code..."
    brew install --cask visual-studio-code
else
    echo "VS Code is already installed."
fi

# Install Cursor IDE if not already installed
if ! brew list --cask cursor &>/dev/null; then
    echo "Installing Cursor IDE..."
    brew install --cask cursor
else
    echo "Cursor IDE is already installed."
fi

# Install Ghostty terminal if not already installed
if ! brew list --cask ghostty &>/dev/null; then
    echo "Installing Ghostty terminal..."
    brew install --cask ghostty
    
    # Prompt about Ghostty configuration
    echo
    echo "Ghostty Configuration:"
    echo "----------------------"
    echo "For a great starter configuration, check out: https://ghostty.zerebos.com/"
    echo "This provides a well-designed configuration that you can customize further."
    read -p "Would you like to open this website now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open "https://ghostty.zerebos.com/"
    fi
else
    echo "Ghostty is already installed."
fi

# Setup modular Ghostty configuration
echo
echo "Ghostty Modular Configuration Setup:"
echo "-----------------------------------"
echo "This will set up a modular configuration approach for Ghostty:"
echo "1. Create a ~/.ghostty directory for your custom configs"
echo "2. Add a reference to your custom config in the main config file"
echo "This allows you to keep configurations modular and easily swap between them."
read -p "Would you like to set up modular Ghostty configuration? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Create the ~/.ghostty directory if it doesn't exist
    if [ ! -d ~/.ghostty ]; then
        echo "Creating ~/.ghostty directory..."
        mkdir -p ~/.ghostty
    else
        echo "~/.ghostty directory already exists."
    fi
    
    # Current date for config file name
    current_date=$(date +%Y.%m.%d)
    config_file_path=~/.ghostty/${current_date}_config
    
    # Create an initial empty config file if it doesn't exist
    if [ ! -f "$config_file_path" ]; then
        echo "Creating initial custom config file at $config_file_path..."
        touch "$config_file_path"
        echo "# Custom Ghostty configuration - Created on $(date)" > "$config_file_path"
        echo "# You can add your custom configurations here" >> "$config_file_path"
        echo "" >> "$config_file_path"
    else
        echo "Custom config file already exists at $config_file_path."
    fi
    
    # Path to the main Ghostty config file
    main_config_path="~/Library/Application Support/com.mitchellh.ghostty/config"
    
    # Check if the main config file exists
    if [ -f "$main_config_path" ]; then
        # Check if the reference to custom config is already there
        if ! grep -q "config-file = ~/.ghostty/" "$main_config_path"; then
            echo "Adding reference to custom config in main Ghostty config file..."
            echo "" >> "$main_config_path"
            echo "### Custom config" >> "$main_config_path"
            echo "config-file = ~/.ghostty/${current_date}_config" >> "$main_config_path"
            echo "Custom configuration reference added successfully."
        else
            echo "Reference to custom config already exists in main Ghostty config."
        fi
    else
        echo "Warning: Main Ghostty config file not found at $main_config_path"
        echo "You may need to launch Ghostty first to generate the default config file,"
        echo "then run this setup again to add the custom config reference."
    fi
fi

# Install FFmpeg for media handling if not already installed
if ! brew list ffmpeg &>/dev/null; then
    echo "Installing FFmpeg..."
    brew install ffmpeg
else
    echo "FFmpeg is already installed."
fi

# Install GitHub CLI if not already installed
if ! brew list gh &>/dev/null; then
    echo "Installing GitHub CLI..."
    brew install gh
    
    # Setup GitHub CLI authentication
    echo "Setting up GitHub CLI..."
    read -p "Would you like to authenticate with GitHub now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        gh auth login
    fi
else
    echo "GitHub CLI is already installed."
fi

# Install GCloud CLI if not already installed
if ! brew list --cask google-cloud-sdk &>/dev/null; then
    echo "Installing Google Cloud SDK..."
    brew install --cask google-cloud-sdk
    
    # Add Google Cloud SDK configuration to gcloud.sh if it doesn't exist
    if [ ! -f ~/code/scripts/gcloud.sh ] || ! grep -q "Google Cloud SDK configuration" ~/code/scripts/gcloud.sh; then
        cat > ~/code/scripts/gcloud.sh << 'EOF'
#!/bin/bash

# Google Cloud SDK configuration
if [ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]; then
    source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
    source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
fi
EOF
        chmod 755 ~/code/scripts/gcloud.sh
    fi
else
    echo "Google Cloud SDK is already installed."
fi

echo "Development tools installation complete!"