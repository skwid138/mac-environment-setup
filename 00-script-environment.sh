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

## Source all custom scripts ##
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
[[ ! -f "$SCRIPTS_DIR/aliases.sh" ]] || source "$SCRIPTS_DIR/aliases.sh"
[[ ! -f "$SCRIPTS_DIR/functions.sh" ]] || source "$SCRIPTS_DIR/functions.sh"
EOF

# Create vars.sh with core environment variables
cat > vars.sh << 'EOF'
#!/bin/bash

# Core environment variables
export EDITOR=vim
export VISUAL=vim

EOF

# Create paths.sh for PATH additions
cat > paths.sh << 'EOF'
#!/bin/bash

# PATH additions will be managed here
# This keeps vars.sh clean and makes path management easier

# Example:
# export PATH="$HOME/bin:$PATH"
EOF

# Create empty tool config files
for file in "${TOOL_CONFIG_FILES[@]}"; do
    touch "$file"
    echo "#!/bin/bash" > "$file"
    echo "" >> "$file"
    echo "# Configuration for ${file%.sh} will be added here during installation" >> "$file"
done

# Download gist files using curl
echo "Downloading aliases.sh from your GitHub gist..."
curl -s https://gist.githubusercontent.com/skwid138/15041e4c3d4992420ae93b25cfadb828/raw > aliases.sh

echo "Downloading functions.sh from your GitHub gist..."
curl -s https://gist.githubusercontent.com/skwid138/8b8de484483f092bb917f07dd0ee6fb0/raw > functions.sh

echo "Downloading cowsay_fortune_lolcat.sh from your GitHub gist..."
curl -s https://gist.githubusercontent.com/skwid138/ff0df971ff1d81b734fb155630f5e499/raw/cowsay_fortune_lolcat.sh > cowsay_fortune_lolcat.sh

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

