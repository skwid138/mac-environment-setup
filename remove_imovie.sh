#!/bin/bash
# Note: Removing the set -e flag to prevent unexpected exits
# set -e

echo "====================================================="
echo "Checking for iMovie and its components..."
echo "====================================================="

# Check for all iMovie components
imovie_components_exist=false
imovie_components_list=""

# Function to check a path and add to components list if it exists
check_component() {
    local path="$1"
    local desc="$2"
    
    if [ -e "$path" ]; then
        imovie_components_exist=true
        imovie_components_list+="- $desc\n"
        return 0
    fi
    return 1
}

# Debug information
echo "Checking for components at:"
echo "- /Applications/iMovie.app"
echo "- $HOME/Library/Containers/com.apple.iMovie"
echo "- $HOME/Library/Caches/com.apple.iMovie"
echo "- $HOME/Library/Application Support/iMovie"
echo "- /Library/Application Support/iMovie"
echo

# Check for various iMovie components with safety checks for path existence
if [ -e "/Applications/iMovie.app" ]; then
    imovie_components_exist=true
    imovie_components_list+="- Main application\n"
fi

if [ -e "$HOME/Library/Containers/com.apple.iMovie" ]; then
    imovie_components_exist=true
    imovie_components_list+="- iMovie container\n"
fi

if [ -e "$HOME/Library/Caches/com.apple.iMovie" ]; then
    imovie_components_exist=true
    imovie_components_list+="- iMovie caches\n"
fi

if [ -e "$HOME/Library/Application Support/iMovie" ]; then
    imovie_components_exist=true
    imovie_components_list+="- User iMovie support files\n"
fi

if [ -e "/Library/Application Support/iMovie" ]; then
    imovie_components_exist=true
    imovie_components_list+="- System iMovie support files\n"
fi

if [ -e "$HOME/Movies/iMovie Library.imovielibrary" ]; then
    imovie_components_exist=true
    imovie_components_list+="- iMovie library\n"
fi

if [ -e "$HOME/Movies/iMovie" ]; then
    imovie_components_exist=true
    imovie_components_list+="- iMovie projects folder\n"
fi

# If nothing exists, skip
if [ "$imovie_components_exist" = false ]; then
    echo "No components of iMovie found. Skipping."
    exit 0
fi

# Report what was found
echo "Found the following iMovie components:"
echo -e "$imovie_components_list"

read -p "Remove iMovie components? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Skipping iMovie removal."
    exit 0
fi

# Function to safely remove a component if it exists
remove_component() {
    local path="$1"
    local desc="$2"
    local need_sudo=$3
    
    if [ -e "$path" ]; then
        if [ "$need_sudo" = true ]; then
            sudo rm -rf "$path"
        else
            rm -rf "$path"
        fi
        echo "Removed $desc"
    fi
}

# Remove components
if [ -e "/Applications/iMovie.app" ]; then
    sudo rm -rf "/Applications/iMovie.app"
    echo "Removed main application"
fi

if [ -e "$HOME/Library/Containers/com.apple.iMovie" ]; then
    rm -rf "$HOME/Library/Containers/com.apple.iMovie"
    echo "Removed iMovie container"
fi

if [ -e "$HOME/Library/Caches/com.apple.iMovie" ]; then
    rm -rf "$HOME/Library/Caches/com.apple.iMovie"
    echo "Removed iMovie caches"
fi

if [ -e "$HOME/Library/Application Support/iMovie" ]; then
    rm -rf "$HOME/Library/Application Support/iMovie"
    echo "Removed user iMovie support files"
fi

if [ -e "/Library/Application Support/iMovie" ]; then
    sudo rm -rf "/Library/Application Support/iMovie"
    echo "Removed system iMovie support files"
fi

if [ -e "$HOME/Movies/iMovie Library.imovielibrary" ]; then
    rm -rf "$HOME/Movies/iMovie Library.imovielibrary"
    echo "Removed iMovie library"
fi

if [ -e "$HOME/Movies/iMovie" ]; then
    rm -rf "$HOME/Movies/iMovie"
    echo "Removed iMovie projects folder"
fi

# Check for any leftover iMovie files
echo "Checking for any leftover iMovie files..."
mdfind "kMDItemKind == 'iMovie Project'" -onlyin ~ 2>/dev/null || true
mdfind "kMDItemKind == 'iMovie Library'" -onlyin ~ 2>/dev/null || true

echo "iMovie components have been removed."
