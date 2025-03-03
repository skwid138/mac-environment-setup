#!/bin/bash
set -e

# Pages
echo "========================================================"
echo "Checking for Pages and its components..."

# Check for all Pages components
pages_exists=false
pages_components_exist=false
pages_components_list=""

# Main app bundle
if [ -d "/Applications/Pages.app" ]; then
    pages_exists=true
    pages_components_exist=true
    pages_components_list+="- Main application\n"
fi

# Container files
if [ -d "$HOME/Library/Containers/com.apple.Pages" ]; then
    pages_components_exist=true
    pages_components_list+="- Container files\n"
fi

# Caches
if [ -d "$HOME/Library/Caches/com.apple.Pages" ]; then
    pages_components_exist=true
    pages_components_list+="- Cache files\n"
fi

# Preferences
if [ -f "$HOME/Library/Preferences/com.apple.Pages.plist" ]; then
    pages_components_exist=true
    pages_components_list+="- Preference files\n"
fi

# If nothing exists, skip
if [ "$pages_components_exist" = false ]; then
    echo "No components of Pages found. Skipping."
else
    # Report what was found
    if [ "$pages_exists" = true ]; then
        echo "Found Pages with the following components:"
    else
        echo "Main app not found, but discovered leftover components:"
    fi
    
    echo -e "$pages_components_list"
    
    read -p "Remove Pages components? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Remove the main app (if it exists)
        if [ -d "/Applications/Pages.app" ]; then
            sudo rm -rf /Applications/Pages.app
            echo "Removed main Pages application."
        fi
        
        # Remove associated container files (if they exist)
        if [ -d "$HOME/Library/Containers/com.apple.Pages" ]; then
            rm -rf "$HOME/Library/Containers/com.apple.Pages"
            echo "Removed Pages container files."
        fi
        
        # Remove caches (if they exist)
        if [ -d "$HOME/Library/Caches/com.apple.Pages" ]; then
            rm -rf "$HOME/Library/Caches/com.apple.Pages"
            echo "Removed Pages cache files."
        fi
        
        # Remove preferences (if they exist)
        if [ -f "$HOME/Library/Preferences/com.apple.Pages.plist" ]; then
            rm -f "$HOME/Library/Preferences/com.apple.Pages.plist"
            echo "Removed Pages preference files."
        fi
        
        # Check for any leftover Pages files
        echo "Checking for any leftover Pages files..."
        mdfind "kMDItemContentType == 'com.apple.iWork.pages.sffpages'" -onlyin ~
        
        echo "Pages has been removed."
    else
        echo "Skipping Pages removal."
    fi
fi
echo

# Numbers
echo "========================================================"
echo "Checking for Numbers and its components..."

# Check for all Numbers components
numbers_exists=false
numbers_components_exist=false
numbers_components_list=""

# Main app bundle
if [ -d "/Applications/Numbers.app" ]; then
    numbers_exists=true
    numbers_components_exist=true
    numbers_components_list+="- Main application\n"
fi

# Container files
if [ -d "$HOME/Library/Containers/com.apple.Numbers" ]; then
    numbers_components_exist=true
    numbers_components_list+="- Container files\n"
fi

# Caches
if [ -d "$HOME/Library/Caches/com.apple.Numbers" ]; then
    numbers_components_exist=true
    numbers_components_list+="- Cache files\n"
fi

# Preferences
if [ -f "$HOME/Library/Preferences/com.apple.Numbers.plist" ]; then
    numbers_components_exist=true
    numbers_components_list+="- Preference files\n"
fi

# If nothing exists, skip
if [ "$numbers_components_exist" = false ]; then
    echo "No components of Numbers found. Skipping."
else
    # Report what was found
    if [ "$numbers_exists" = true ]; then
        echo "Found Numbers with the following components:"
    else
        echo "Main app not found, but discovered leftover components:"
    fi
    
    echo -e "$numbers_components_list"
    
    read -p "Remove Numbers components? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Remove the main app (if it exists)
        if [ -d "/Applications/Numbers.app" ]; then
            sudo rm -rf /Applications/Numbers.app
            echo "Removed main Numbers application."
        fi
        
        # Remove associated container files (if they exist)
        if [ -d "$HOME/Library/Containers/com.apple.Numbers" ]; then
            rm -rf "$HOME/Library/Containers/com.apple.Numbers"
            echo "Removed Numbers container files."
        fi
        
        # Remove caches (if they exist)
        if [ -d "$HOME/Library/Caches/com.apple.Numbers" ]; then
            rm -rf "$HOME/Library/Caches/com.apple.Numbers"
            echo "Removed Numbers cache files."
        fi
        
        # Remove preferences (if they exist)
        if [ -f "$HOME/Library/Preferences/com.apple.Numbers.plist" ]; then
            rm -f "$HOME/Library/Preferences/com.apple.Numbers.plist"
            echo "Removed Numbers preference files."
        fi
        
        # Check for any leftover Numbers files
        echo "Checking for any leftover Numbers files..."
        mdfind "kMDItemContentType == 'com.apple.iWork.numbers.sffnumbers'" -onlyin ~
        
        echo "Numbers has been removed."
    else
        echo "Skipping Numbers removal."
    fi
fi
echo

# Keynote
echo "========================================================"
echo "Checking for Keynote and its components..."

# Check for all Keynote components
keynote_exists=false
keynote_components_exist=false
keynote_components_list=""

# Main app bundle
if [ -d "/Applications/Keynote.app" ]; then
    keynote_exists=true
    keynote_components_exist=true
    keynote_components_list+="- Main application\n"
fi

# Container files
if [ -d "$HOME/Library/Containers/com.apple.iWork.Keynote" ]; then
    keynote_components_exist=true
    keynote_components_list+="- Container files\n"
fi

# Caches
if [ -d "$HOME/Library/Caches/com.apple.iWork.Keynote" ]; then
    keynote_components_exist=true
    keynote_components_list+="- Cache files\n"
fi

# Preferences
if [ -f "$HOME/Library/Preferences/com.apple.iWork.Keynote.plist" ]; then
    keynote_components_exist=true
    keynote_components_list+="- Preference files\n"
fi

# If nothing exists, skip
if [ "$keynote_components_exist" = false ]; then
    echo "No components of Keynote found. Skipping."
else
    # Report what was found
    if [ "$keynote_exists" = true ]; then
        echo "Found Keynote with the following components:"
    else
        echo "Main app not found, but discovered leftover components:"
    fi
    
    echo -e "$keynote_components_list"
    
    read -p "Remove Keynote components? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Remove the main app (if it exists)
        if [ -d "/Applications/Keynote.app" ]; then
            sudo rm -rf /Applications/Keynote.app
            echo "Removed main Keynote application."
        fi
        
        # Remove associated container files (if they exist)
        if [ -d "$HOME/Library/Containers/com.apple.iWork.Keynote" ]; then
            rm -rf "$HOME/Library/Containers/com.apple.iWork.Keynote"
            echo "Removed Keynote container files."
        fi
        
        # Remove caches (if they exist)
        if [ -d "$HOME/Library/Caches/com.apple.iWork.Keynote" ]; then
            rm -rf "$HOME/Library/Caches/com.apple.iWork.Keynote"
            echo "Removed Keynote cache files."
        fi
        
        # Remove preferences (if they exist)
        if [ -f "$HOME/Library/Preferences/com.apple.iWork.Keynote.plist" ]; then
            rm -f "$HOME/Library/Preferences/com.apple.iWork.Keynote.plist"
            echo "Removed Keynote preference files."
        fi
        
        # Check for any leftover Keynote files
        echo "Checking for any leftover Keynote files..."
        mdfind "kMDItemContentType == 'com.apple.iWork.keynote.sffkey'" -onlyin ~
        
        echo "Keynote has been removed."
    else
        echo "Skipping Keynote removal."
    fi
fi
