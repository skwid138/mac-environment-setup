#!/bin/bash
set -e

echo "Setting up media conversion utilities..."

# Install FFmpeg if not already installed
if ! brew list ffmpeg &>/dev/null; then
    echo "Installing FFmpeg (required for media conversion)..."
    read -p "Would you like to install FFmpeg for media conversion? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        brew install ffmpeg
        echo "FFmpeg installed successfully."
    else
        echo "Skipping FFmpeg installation. Note that media conversion utilities may not work properly without it."
    fi
else
    echo "FFmpeg is already installed."
fi

# Download mov2gif script from GitHub gist
echo "Setting up mov2gif utility from GitHub gist..."

# Create a directory for scripts if it doesn't exist
mkdir -p ~/bin

# Check if the script already exists
if [ ! -f ~/bin/mov2gif.sh ]; then
    echo "Downloading mov2gif.sh from GitHub gist..."
    read -p "Would you like to download the mov2gif utility from GitHub? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        curl -s https://gist.githubusercontent.com/skwid138/56d1b71c87c626d7a7b81873b498ecd8/raw -o ~/bin/mov2gif.sh
        chmod +x ~/bin/mov2gif.sh
        echo "mov2gif.sh downloaded and set as executable."
    else
        echo "Skipping mov2gif.sh download."
    fi
else
    echo "mov2gif.sh already exists in ~/bin."
    
    # Ask if user wants to update it
    read -p "Would you like to update mov2gif.sh? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        curl -s https://gist.githubusercontent.com/skwid138/56d1b71c87c626d7a7b81873b498ecd8/raw -o ~/bin/mov2gif.sh
        chmod +x ~/bin/mov2gif.sh
        echo "mov2gif.sh updated."
    fi
fi

# Add alias to aliases.sh if it doesn't already exist
if [ -f ~/code/scripts/aliases.sh ]; then
    if ! grep -q "alias mov2gif=" ~/code/scripts/aliases.sh; then
        echo "Adding mov2gif alias to aliases.sh..."
        read -p "Would you like to add the mov2gif alias to aliases.sh? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "" >> ~/code/scripts/aliases.sh
            echo "# Convert .mov file to .gif" >> ~/code/scripts/aliases.sh
            echo "alias mov2gif='~/bin/mov2gif.sh'" >> ~/code/scripts/aliases.sh
            
            echo "mov2gif alias added to aliases.sh."
        else
            echo "Skipping addition of mov2gif alias."
        fi
    else
        echo "mov2gif alias already exists in aliases.sh."
    fi
else
    echo "aliases.sh not found. Creating file with mov2gif alias..."
    
    read -p "Would you like to create aliases.sh with the mov2gif alias? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Create aliases.sh with mov2gif alias
        cat > ~/code/scripts/aliases.sh << 'EOF'
#!/bin/bash

# Convert .mov file to .gif
alias mov2gif='~/bin/mov2gif.sh'
EOF
        
        chmod 755 ~/code/scripts/aliases.sh
        echo "aliases.sh created with mov2gif alias."
    else
        echo "Skipping creation of aliases.sh."
    fi
fi

# Add clipflip function to functions.sh
echo "Adding clipflip function to functions.sh..."

if [ -f ~/code/scripts/functions.sh ]; then
    if ! grep -q "clipflip()" ~/code/scripts/functions.sh; then
        read -p "Would you like to add the clipflip video conversion function to functions.sh? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cat >> ~/code/scripts/functions.sh << 'EOF'

## Convert a video's format to a different format using FFmpeg
## Example: clipflip input.mov output.mp4
# The first argument is the input file, and the second argument is the output file
clipflip() {
    local input="$1"
    local output="$2"
    ffmpeg -i "$input" -c:v libx264 -c:a aac "$output"
}
EOF
            echo "clipflip function added to functions.sh."
        else
            echo "Skipping addition of clipflip function."
        fi
    else
        echo "clipflip function already exists in functions.sh."
    fi
else
    echo "functions.sh not found. Creating file with clipflip function..."
    
    read -p "Would you like to create functions.sh with the clipflip function? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Create functions.sh with clipflip function
        cat > ~/code/scripts/functions.sh << 'EOF'
#!/bin/bash

## Convert a video's format to a different format using FFmpeg
## Example: clipflip input.mov output.mp4
# The first argument is the input file, and the second argument is the output file
clipflip() {
    local input="$1"
    local output="$2"
    ffmpeg -i "$input" -c:v libx264 -c:a aac "$output"
}
EOF
        
        chmod 755 ~/code/scripts/functions.sh
        echo "functions.sh created with clipflip function."
    else
        echo "Skipping creation of functions.sh."
    fi
fi

echo "Media conversion utilities setup complete!"
