#!/bin/bash
set -e

echo "Setting up GNU tools to replace macOS defaults..."

# Function to install a GNU tool if not already installed
install_gnu_tool() {
    local tool_name=$1
    local display_name=$2
    
    # If display name is not provided, use the tool name
    if [ -z "$display_name" ]; then
        display_name=$tool_name
    fi
    
    if ! brew list $tool_name &>/dev/null; then
        echo "Installing $display_name..."
        read -p "Would you like to install $display_name? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            brew install $tool_name
            echo "$display_name installed successfully."
        else
            echo "Skipping $display_name installation."
        fi
    else
        echo "$display_name is already installed."
    fi
}

# Install each GNU tool with prompt
echo "These GNU tools provide enhanced functionality over the macOS defaults."
install_gnu_tool "coreutils" "GNU coreutils (ls, cp, mv, etc.)"
install_gnu_tool "grep" "GNU grep"
install_gnu_tool "gnu-sed" "GNU sed"
install_gnu_tool "gawk" "GNU awk"
install_gnu_tool "findutils" "GNU findutils (find, locate, etc.)"

# Update paths.sh to include GNU tools in PATH
if [ -f ~/code/scripts/paths.sh ]; then
    echo "Checking paths.sh configuration..."
    
    # Check if GNU paths are already in the file
    if ! grep -q "GNU coreutils" ~/code/scripts/paths.sh; then
        echo "Updating paths.sh to prioritize GNU tools..."
        
        read -p "Would you like to update paths.sh to prioritize GNU tools? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Create a temporary file with the GNU paths
            cat > /tmp/gnu_paths.sh << 'EOF'
#!/bin/bash

# GNU coreutils (head, tail, ls, cp, mv, rm, cat, sort, uniq, etc.)
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# GNU grep
export PATH="$(brew --prefix grep)/libexec/gnubin:$PATH"

# GNU sed
export PATH="$(brew --prefix gnu-sed)/libexec/gnubin:$PATH"

# GNU awk
export PATH="$(brew --prefix gawk)/libexec/gnubin:$PATH"

# GNU find
export PATH="$(brew --prefix findutils)/libexec/gnubin:$PATH"

# Homebrew packages
export PATH="/opt/homebrew/bin:$PATH"

export PATH="$HOME/bin:$PATH"
EOF
            
            # Replace paths.sh with our new version
            mv /tmp/gnu_paths.sh ~/code/scripts/paths.sh
            chmod 755 ~/code/scripts/paths.sh
            
            echo "paths.sh updated to prioritize GNU tools."
        else
            echo "Skipping paths.sh update."
        fi
    else
        echo "paths.sh already includes GNU tool paths."
    fi
else
    echo "paths.sh not found. Creating new file with GNU tool paths..."
    
    read -p "Would you like to create paths.sh with GNU tool paths? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Create paths.sh with GNU tool paths
        cat > ~/code/scripts/paths.sh << 'EOF'
#!/bin/bash

# GNU coreutils (head, tail, ls, cp, mv, rm, cat, sort, uniq, etc.)
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# GNU grep
export PATH="$(brew --prefix grep)/libexec/gnubin:$PATH"

# GNU sed
export PATH="$(brew --prefix gnu-sed)/libexec/gnubin:$PATH"

# GNU awk
export PATH="$(brew --prefix gawk)/libexec/gnubin:$PATH"

# GNU find
export PATH="$(brew --prefix findutils)/libexec/gnubin:$PATH"

# Homebrew packages
export PATH="/opt/homebrew/bin:$PATH"

export PATH="$HOME/bin:$PATH"
EOF
        
        chmod 755 ~/code/scripts/paths.sh
        echo "paths.sh created with GNU tool paths."
    else
        echo "Skipping paths.sh creation."
    fi
fi

echo "GNU tools setup complete!"
