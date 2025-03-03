#!/bin/bash
set -e

echo "Setting up ZSH customizations with Zplug..."

# Install Zplug if not already installed
if ! brew list zplug &>/dev/null; then
    echo "Installing Zplug..."
    brew install zplug
else
    echo "Zplug is already installed."
fi

# Create zsh_plugins.sh in the scripts directory
echo "Creating ZSH plugins configuration file with Zplug..."
cat > ~/code/scripts/zsh_plugins.sh << 'EOF'
#!/bin/bash

# Source Zplug
if [ -f "/opt/homebrew/opt/zplug/init.zsh" ]; then
    source "/opt/homebrew/opt/zplug/init.zsh"
    
    # Define plugins
    zplug "spaceship-prompt/spaceship-prompt", use:spaceship.zsh, from:github, as:theme
    zplug "zsh-users/zsh-syntax-highlighting", defer:2
    zplug "zsh-users/zsh-autosuggestions"
    
    # Install plugins if there are plugins that have not been installed
    if ! zplug check; then
        printf "Install missing Zplug plugins? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi
    
    # Load plugins
    zplug load
    
    # Spaceship prompt configuration
    SPACESHIP_PROMPT_ORDER=(
      user          # Username section
      dir           # Current directory section
      host          # Hostname section
      git           # Git section (git_branch + git_status)
      exec_time     # Execution time
      line_sep      # Line break
      jobs          # Background jobs indicator
      exit_code     # Exit code section
      char          # Prompt character
    )
    SPACESHIP_PROMPT_ADD_NEWLINE=false
    SPACESHIP_CHAR_SYMBOL="❯ "
    SPACESHIP_CHAR_SUFFIX=" "
fi
EOF

# Set executable permissions
chmod 755 ~/code/scripts/zsh_plugins.sh

# Update init.sh to source the new file if it's not already included
if ! grep -q "zsh_plugins.sh" ~/code/scripts/init.sh; then
    # Find the line with "Shell customizations" and add our new file after it
    sed -i '' '/## Shell customizations/a\
[[ ! -f "$SCRIPTS_DIR/zsh_plugins.sh" ]] || source "$SCRIPTS_DIR/zsh_plugins.sh"
' ~/code/scripts/init.sh
    echo "Updated init.sh to source ZSH plugins"
else
    echo "init.sh already configured to source ZSH plugins"
fi

# Prompt for Ghostty configuration
echo
echo "Ghostty Configuration Recommendation:"
echo "-----------------------------------"
echo "Would you like to use zerebos's Ghostty configuration as a starting point?"
echo "This provides a well-designed configuration for your Ghostty terminal."
echo "You can find it at: https://ghostty.zerebos.com/ or https://github.com/zerebos/ghostty-config"
read -p "Open the Ghostty configuration website now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open "https://ghostty.zerebos.com/"
fi

echo
echo "ZSH customizations with Zplug setup complete!"
echo "Restart your terminal or run 'source ~/code/scripts/init.sh' to apply changes."
