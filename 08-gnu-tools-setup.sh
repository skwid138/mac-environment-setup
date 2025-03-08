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

# Install upgraded Bash if not already installed
echo "====================================================="
echo "Installing upgraded Bash shell"
echo "====================================================="

if ! brew list bash &>/dev/null; then
    echo "macOS comes with an older version of Bash (3.2.57). Would you like to install the latest Bash version?"
    read -p "Install latest Bash? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        brew install bash
        
        # Get the path to the new Bash
        NEW_BASH_PATH="$(brew --prefix)/bin/bash"
        
        # Check if the new Bash is already in /etc/shells
        if ! grep -q "$NEW_BASH_PATH" /etc/shells; then
            echo "Adding new Bash to /etc/shells (may require password)..."
            echo "$NEW_BASH_PATH" | sudo tee -a /etc/shells > /dev/null
            
            # Ask if user wants to change their default shell
            echo
            echo "Would you like to set the new Bash as your default shell?"
            echo "Current bash version: $(bash --version | head -n 1)"
            echo "New bash version:     $($NEW_BASH_PATH --version | head -n 1)"
            read -p "Change default shell? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                chsh -s "$NEW_BASH_PATH" "$USER"
                echo "Default shell changed to new Bash. Changes will take effect in new terminal sessions."
            else
                echo "Default shell not changed. You can still use the new Bash by running: $NEW_BASH_PATH"
            fi
        else
            echo "New Bash is already in /etc/shells."
            
            # Check if it's already the default shell
            if [[ "$SHELL" != "$NEW_BASH_PATH" ]]; then
                echo "Would you like to set the new Bash as your default shell?"
                echo "Current bash version: $(bash --version | head -n 1)"
                echo "New bash version:     $($NEW_BASH_PATH --version | head -n 1)"
                read -p "Change default shell? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    chsh -s "$NEW_BASH_PATH" "$USER"
                    echo "Default shell changed to new Bash. Changes will take effect in new terminal sessions."
                else
                    echo "Default shell not changed."
                fi
            else
                echo "New Bash is already your default shell."
            fi
        fi
        
        echo "Bash installation and configuration complete."
    else
        echo "Skipping Bash installation."
    fi
else
    echo "Upgraded Bash is already installed."
    
    # Get the path to the new Bash
    NEW_BASH_PATH="$(brew --prefix)/bin/bash"
    
    # Check if it's already the default shell
    if [[ "$SHELL" != "$NEW_BASH_PATH" ]]; then
        echo "Would you like to set the Homebrew Bash as your default shell?"
        echo "Current shell: $SHELL ($(bash --version | head -n 1))"
        echo "Homebrew Bash: $NEW_BASH_PATH ($($NEW_BASH_PATH --version | head -n 1))"
        read -p "Change default shell? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Check if the new Bash is already in /etc/shells
            if ! grep -q "$NEW_BASH_PATH" /etc/shells; then
                echo "Adding Homebrew Bash to /etc/shells (may require password)..."
                echo "$NEW_BASH_PATH" | sudo tee -a /etc/shells > /dev/null
            fi
            
            chsh -s "$NEW_BASH_PATH" "$USER"
            echo "Default shell changed to Homebrew Bash. Changes will take effect in new terminal sessions."
        else
            echo "Default shell not changed."
        fi
    else
        echo "Homebrew Bash is already your default shell."
    fi
fi

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
