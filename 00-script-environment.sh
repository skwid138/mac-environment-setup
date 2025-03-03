#!/bin/bash
# ----------------------
# 00-script-environment.sh
# ----------------------
#!/bin/bash
set -e

echo "Setting up custom script environment..."

# Create necessary directories
mkdir -p ~/code/scripts

# Change to the scripts directory
cd ~/code/scripts

# Define script files and their permissions
SCRIPT_FILES=("init.sh" "vars.sh" "paths.sh" "aliases.sh" "functions.sh" "cowsay_fortune_lolcat.sh")
TOOL_CONFIG_FILES=("nvm.sh" "conda.sh" "gcloud.sh")
SCRIPT_PERMISSIONS=755

# Create init.sh with dynamic paths and modular structure
cat > init.sh << 'EOF'
#!/bin/bash

## Determine script location regardless of source/execution context
if [ -n "$ZSH_VERSION" ]; then
  # For zsh
  SCRIPTS_DIR="${0:A:h}"
  if [[ "$SCRIPTS_DIR" == "." ]]; then
    # When sourced from .zshrc
    SCRIPTS_DIR="$HOME/code/scripts"
  fi
elif [ -n "$BASH_VERSION" ]; then
  # For bash
  SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
else
  # Fallback to absolute path
  SCRIPTS_DIR="$HOME/code/scripts"
fi

## Core environment
[[ ! -f "$SCRIPTS_DIR/vars.sh" ]] || source "$SCRIPTS_DIR/vars.sh"
[[ ! -f "$SCRIPTS_DIR/paths.sh" ]] || source "$SCRIPTS_DIR/paths.sh"

## Tool-specific configs (only loaded if tool is installed)
[[ ! -d "$HOME/.nvm" ]] || [[ ! -f "$SCRIPTS_DIR/nvm.sh" ]] || source "$SCRIPTS_DIR/nvm.sh"
[[ ! -d "$HOME/miniconda3" ]] || [[ ! -f "$SCRIPTS_DIR/conda.sh" ]] || source "$SCRIPTS_DIR/conda.sh"
[[ ! -f "$SCRIPTS_DIR/gcloud.sh" ]] || source "$SCRIPTS_DIR/gcloud.sh"

## Fun terminal additions
[[ ! -f "$SCRIPTS_DIR/cowsay_fortune_lolcat.sh" ]] || source "$SCRIPTS_DIR/cowsay_fortune_lolcat.sh"

## Shell customizations
[[ ! -f "$SCRIPTS_DIR/zsh_plugins.sh" ]] || source "$SCRIPTS_DIR/zsh_plugins.sh"
[[ ! -f "$SCRIPTS_DIR/aliases.sh" ]] || source "$SCRIPTS_DIR/aliases.sh"
[[ ! -f "$SCRIPTS_DIR/functions.sh" ]] || source "$SCRIPTS_DIR/functions.sh"

EOF

# Create vars.sh with core environment variables
if [ ! -f ~/code/scripts/vars.sh ] || ! grep -q "Core environment variables" ~/code/scripts/vars.sh; then
cat > vars.sh << 'EOF'
#!/bin/bash

# Core environment variables
export EDITOR=vim
export VISUAL=vim

EOF
else
    echo "vars.sh already exists."
fi

# Create paths.sh for PATH additions
if [ ! -f ~/code/scripts/paths.sh ] || ! grep -q "PATH additions" ~/code/scripts/paths.sh; then
cat > paths.sh << 'EOF'
#!/bin/bash

export PATH="/opt/homebrew/bin:$PATH"

export PATH="$HOME/bin:$PATH"

EOF
else
    echo "paths.sh already exists."
fi

# Create empty tool config files
for file in "${TOOL_CONFIG_FILES[@]}"; do
    touch "$file"
    echo "#!/bin/bash" > "$file"
    echo "" >> "$file"
    echo "# Configuration for ${file%.sh} will be added here during installation" >> "$file"
done

# Download gist files using curl
if [ ! -f ~/code/scripts/aliases.sh ] || ! grep -q "alias lsd=" ~/code/scripts/aliases.sh; then
    echo "Downloading aliases.sh from your GitHub gist..."
    curl -s https://gist.githubusercontent.com/skwid138/15041e4c3d4992420ae93b25cfadb828/raw > aliases.sh
else
    echo "aliases.sh already exists."
fi

if [ ! -f ~/code/scripts/functions.sh ] || ! grep -q "#!/bin/bash" ~/code/scripts/functions.sh; then
    echo "Downloading functions.sh from your GitHub gist..."
    curl -s https://gist.githubusercontent.com/skwid138/8b8de484483f092bb917f07dd0ee6fb0/raw > functions.sh
else
    echo "functions.sh already exists."
fi

if [ ! -f ~/code/scripts/cowsay_fortune_lolcat.sh ] || ! grep -q "cowsay character" ~/code/scripts/cowsay_fortune_lolcat.sh; then
    echo "Downloading cowsay_fortune_lolcat.sh from your GitHub gist..."
    curl -s https://gist.githubusercontent.com/skwid138/ff0df971ff1d81b734fb155630f5e499/raw/cowsay_fortune_lolcat.sh > cowsay_fortune_lolcat.sh
else
    echo "cowsay_fortune_lolcat.sh already exists."
fi

# Set permissions for all script files
for script in "${SCRIPT_FILES[@]}" "${TOOL_CONFIG_FILES[@]}"; do
    chmod ${SCRIPT_PERMISSIONS} "$script"
    echo "Set permissions for $script to ${SCRIPT_PERMISSIONS}"
done

# Update .zshrc to source the init.sh file
if ! grep -q "Source custom scripts" ~/.zshrc; then
    echo "" >> ~/.zshrc
    echo "### Source custom scripts ###" >> ~/.zshrc
    echo "[[ ! -f ~/code/scripts/init.sh ]] || source ~/code/scripts/init.sh" >> ~/.zshrc
    echo "Updated ~/.zshrc to source your custom scripts"
else
    echo "~/.zshrc already contains custom scripts sourcing"
fi

echo "Custom script environment setup complete!"

