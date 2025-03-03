#!/bin/bash
# Note: Removing the set -e flag to prevent unexpected exits
# set -e

echo "====================================================="
echo "Checking for GarageBand and its components..."
echo "====================================================="

# Check for all GarageBand components
gb_components_exist=false
gb_components_list=""

# Debug information
echo "Checking for components at:"
echo "- /Applications/GarageBand.app"
echo "- /Library/Application Support/GarageBand"
echo "- /Library/Application Support/Logic"
echo "- /Library/Audio/Apple Loops"
echo "- $HOME/Library/Application Support/GarageBand"
echo "- $HOME/Library/Application Support/Audio/Apple Loops"
echo "- $HOME/Library/Containers/com.apple.garageband"
echo "- $HOME/Music/GarageBand"
echo "- /Library/Caches/com.apple.apple-loopsd"
echo "- $HOME/Library/Caches/com.apple.garageband"
echo

# Check each component individually and directly
if [ -e "/Applications/GarageBand.app" ]; then
    gb_components_exist=true
    gb_components_list+="- Main application\n"
fi

if [ -e "/Library/Application Support/GarageBand" ]; then
    gb_components_exist=true
    gb_components_list+="- Sound library content\n"
fi

if [ -e "/Library/Application Support/Logic" ]; then
    gb_components_exist=true
    gb_components_list+="- Logic sound library (used by GarageBand)\n"
fi

if [ -e "/Library/Audio/Apple Loops" ]; then
    gb_components_exist=true
    gb_components_list+="- Apple Loops sound library\n"
fi

if [ -e "$HOME/Library/Application Support/GarageBand" ]; then
    gb_components_exist=true
    gb_components_list+="- User GarageBand files\n"
fi

if [ -e "$HOME/Library/Application Support/Audio/Apple Loops" ]; then
    gb_components_exist=true
    gb_components_list+="- User Apple Loops\n"
fi

if [ -e "$HOME/Library/Containers/com.apple.garageband" ]; then
    gb_components_exist=true
    gb_components_list+="- GarageBand container\n"
fi

if [ -e "$HOME/Music/GarageBand" ]; then
    gb_components_exist=true
    gb_components_list+="- GarageBand music files\n"
fi

if [ -e "/Library/Caches/com.apple.apple-loopsd" ]; then
    gb_components_exist=true
    gb_components_list+="- Apple Loops index\n"
fi

if [ -e "$HOME/Library/Caches/com.apple.garageband" ]; then
    gb_components_exist=true
    gb_components_list+="- GarageBand caches\n"
fi

# If nothing exists, skip
if [ "$gb_components_exist" = false ]; then
    echo "No components of GarageBand found. Skipping."
    exit 0
fi

# Report what was found
echo "Found the following GarageBand components:"
echo -e "$gb_components_list"

read -p "Remove GarageBand components? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping GarageBand removal."
    exit 0
fi

# Remove components with direct checks
if [ -e "/Applications/GarageBand.app" ]; then
    sudo rm -rf "/Applications/GarageBand.app"
    echo "Removed main application"
fi

if [ -e "/Library/Application Support/GarageBand" ]; then
    sudo rm -rf "/Library/Application Support/GarageBand"
    echo "Removed sound library content"
fi

if [ -e "/Library/Application Support/Logic" ]; then
    sudo rm -rf "/Library/Application Support/Logic"
    echo "Removed Logic sound library"
fi

if [ -e "/Library/Audio/Apple Loops" ]; then
    sudo rm -rf "/Library/Audio/Apple Loops"
    echo "Removed Apple Loops sound library"
fi

if [ -e "$HOME/Library/Application Support/GarageBand" ]; then
    rm -rf "$HOME/Library/Application Support/GarageBand"
    echo "Removed user GarageBand files"
fi

if [ -e "$HOME/Library/Application Support/Audio/Apple Loops" ]; then
    rm -rf "$HOME/Library/Application Support/Audio/Apple Loops"
    echo "Removed user Apple Loops"
fi

if [ -e "$HOME/Library/Containers/com.apple.garageband" ]; then
    rm -rf "$HOME/Library/Containers/com.apple.garageband"
    echo "Removed GarageBand container"
fi

if [ -e "$HOME/Music/GarageBand" ]; then
    rm -rf "$HOME/Music/GarageBand"
    echo "Removed GarageBand music files"
fi

if [ -e "/Library/Caches/com.apple.apple-loopsd" ]; then
    sudo rm -rf "/Library/Caches/com.apple.apple-loopsd"
    echo "Removed Apple Loops index"
fi

if [ -e "$HOME/Library/Caches/com.apple.garageband" ]; then
    rm -rf "$HOME/Library/Caches/com.apple.garageband"
    echo "Removed GarageBand caches"
fi

# Check for any leftover GarageBand files
echo "Checking for any leftover GarageBand files..."
mdfind "kMDItemKind == 'GarageBand Document'" -onlyin ~ 2>/dev/null || true

echo "GarageBand components have been removed."
