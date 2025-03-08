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

# Create/update zsh_config.sh with custom ZSH configurations if it doesn't exist or is empty
if [ ! -f ~/code/scripts/zsh_config.sh ] || ! grep -q "Case-insensitive completion" ~/code/scripts/zsh_config.sh; then
    echo "Creating ZSH custom configuration file..."
    read -p "Would you like to set up ZSH keyboard shortcuts and completion configuration? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cat > ~/code/scripts/zsh_config.sh << 'EOF'
#!/bin/bash

# Case-insensitive completion
# m:{a-z}={A-Z} - Match lowercase to uppercase
# m:{A-Z}={a-z} - Match uppercase to lowercase
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Advanced configuration with partial-word completion
# 'r:|=*' - Right side can match anything
# 'l:|=*' - Left side can match anything
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=*'

# Remind myself to use the native shortcuts
beginning_of_line_with_reminder() {
  zle beginning-of-line
  zle -M "▶ TIP: You can also use Ctrl+A to move to beginning of line"
  # Set up a one-time hook to clear the message on next keypress
  zle -N self-insert clear_message_and_self_insert
}
zle -N beginning_of_line_with_reminder

end_of_line_with_reminder() {
  zle end-of-line
  zle -M "▶ TIP: You can also use Ctrl+E to move to end of line"
  # Set up a one-time hook to clear the message on next keypress
  zle -N self-insert clear_message_and_self_insert
}
zle -N end_of_line_with_reminder

# Clear the message on next keypress
clear_message_and_self_insert() {
  # Clear the message
  zle -M ""
  # Restore the original self-insert widget
  zle -A .self-insert self-insert
  # Process the current key press
  zle .self-insert
}
zle -N clear_message_and_self_insert

# Add fn+left/right shortcuts with reminder to use native shortcuts
bindkey '^[[H' beginning_of_line_with_reminder  # fn+left arrow 
bindkey '^[[F' end_of_line_with_reminder        # fn+right arrow
EOF

        # Set executable permissions
        chmod 755 ~/code/scripts/zsh_config.sh
        echo "ZSH custom configuration file created."
    else
        echo "Skipping ZSH keyboard shortcuts configuration."
    fi
else
    echo "ZSH custom configuration file already exists."
fi

# Set executable permissions for zsh_plugins.sh
chmod 755 ~/code/scripts/zsh_plugins.sh

# Update init.sh to source the new files if they're not already included
if ! grep -q "zsh_plugins.sh" ~/code/scripts/init.sh; then
    # Find the line with "Shell customizations" and add our new file after it
    sed -i '' '/## Shell customizations/a\
[[ ! -f "$SCRIPTS_DIR/zsh_plugins.sh" ]] || source "$SCRIPTS_DIR/zsh_plugins.sh"
' ~/code/scripts/init.sh
    echo "Updated init.sh to source ZSH plugins"
else
    echo "init.sh already configured to source ZSH plugins"
fi

# Update init.sh to source zsh_config.sh if it's not already included
if ! grep -q "zsh_config.sh" ~/code/scripts/init.sh; then
    echo "Updating init.sh to source zsh_config.sh..."
    
    # Find the line with "Shell customizations" and add our new file after it
    sed -i '' '/## Shell customizations/a\
[[ ! -f "$SCRIPTS_DIR/zsh_config.sh" ]] || source "$SCRIPTS_DIR/zsh_config.sh"
' ~/code/scripts/init.sh
    
    echo "Updated init.sh to source ZSH custom configuration."
else
    echo "init.sh already configured to source ZSH custom configuration."
fi

# Now install the plugins directly during setup
echo "Installing Zplug plugins..."

# Create a temporary script to install plugins
cat > /tmp/install_zplug_plugins.zsh << 'EOF'
#!/usr/bin/env zsh

# Source Zplug
source "/opt/homebrew/opt/zplug/init.zsh"

# Define plugins (same as in zsh_plugins.sh)
zplug "spaceship-prompt/spaceship-prompt", use:spaceship.zsh, from:github, as:theme
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"

# Install plugins without prompting
zplug install

# Check if installation was successful
if zplug check; then
    echo "All plugins successfully installed!"
    exit 0
else
    echo "Some plugins could not be installed. Please check manually."
    exit 1
fi
EOF

# Make the temporary script executable
chmod +x /tmp/install_zplug_plugins.zsh

# Run the temporary script with zsh
echo "Running Zplug installation..."
zsh /tmp/install_zplug_plugins.zsh

# Clean up
rm /tmp/install_zplug_plugins.zsh

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
