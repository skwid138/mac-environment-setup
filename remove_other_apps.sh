#!/bin/bash
# These apps are all system apps protected by SIP
# You will need to disable SIP in Recovery Mode to remove them (not recommended)
# In addition to opening the system up to potential security risks, it will also break some system features
# It's also likely the apps would be reinstalled by the system if you don't disable SIP

remove_app() {
    local app_name=$1
    local bundle_id=$2
    local display_name=$3  # Optional, defaults to app_name
    local safety_level=$4  # "safe", "caution", or "system"
    
    if [ -z "$display_name" ]; then
        display_name=$app_name
    fi
    
    echo "========================================================"
    echo "Checking for $display_name and its components..."
    
    # Check for all possible app components
    local app_exists=false
    local app_path=""
    local system_app_path=""
    local components_exist=false
    local components_list=""
    
    # Check for both locations: /Applications and /System/Applications
    if [ -d "/Applications/$app_name.app" ]; then
        app_exists=true
        components_exist=true
        app_path="/Applications/$app_name.app"
        components_list+="- Main application (in /Applications)\n"
    fi
    
    if [ -d "/System/Applications/$app_name.app" ]; then
        app_exists=true
        components_exist=true
        system_app_path="/System/Applications/$app_name.app"
        components_list+="- Main application (in /System/Applications - SIP protected)\n"
    fi
    
    # Container files
    if [ -d "$HOME/Library/Containers/$bundle_id" ]; then
        components_exist=true
        components_list+="- Container files\n"
    fi
    
    # Caches
    if [ -d "$HOME/Library/Caches/$bundle_id" ]; then
        components_exist=true
        components_list+="- Cache files\n"
    fi
    
    # Application support
    if [ -d "$HOME/Library/Application Support/$app_name" ]; then
        components_exist=true
        components_list+="- Application support files\n"
    fi
    
    # Preferences
    if [ -f "$HOME/Library/Preferences/$bundle_id.plist" ]; then
        components_exist=true
        components_list+="- Preference files\n"
    fi
    
    # If nothing exists, skip
    if [ "$components_exist" = false ]; then
        echo "No components of $display_name found. Skipping."
        echo
        return 0
    fi
    
    # Report what was found
    if [ "$app_exists" = true ]; then
        echo "Found $display_name with the following components:"
    else
        echo "Main app not found, but discovered leftover components:"
    fi
    
    echo -e "$components_list"
    
    # Display appropriate warning based on safety level
    if [ "$safety_level" = "caution" ]; then
        echo "⚠️  CAUTION: Removing this app may affect some system functionality."
        echo "    It can typically be reinstalled from the App Store if needed."
    elif [ "$safety_level" = "system" ]; then
        echo "⚠️  WARNING: This is a core system app. Removing it is not recommended."
        echo "    Removal could impact essential macOS functionality."
        echo "    Only proceed if you're absolutely certain."
    fi
    
    # Special warning for System Applications
    if [ -n "$system_app_path" ]; then
        echo "⚠️  IMPORTANT: This app is located in /System/Applications."
        echo "    This directory is protected by System Integrity Protection (SIP)."
        echo "    You'll need to disable SIP in Recovery Mode to remove this app."
        echo "    Removing system apps is not recommended without good reason."
        echo
        echo "    To disable SIP (do this only if you're sure):"
        echo "    1. Restart and hold Command+R during startup to enter Recovery Mode"
        echo "    2. Open Terminal from the Utilities menu"
        echo "    3. Run: csrutil disable"
        echo "    4. Restart normally and run this script again"
        echo "    5. Remember to re-enable SIP afterward with: csrutil enable"
        echo
        read -p "Skip removal since SIP needs to be disabled first? (Y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            echo "Continuing with removal of non-SIP-protected components..."
        else
            echo "Skipping $display_name removal. Run again after disabling SIP if needed."
            echo
            return 0
        fi
    fi
    
    read -p "Remove $display_name components? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping $display_name removal."
        echo
        return 0
    fi
    
    # Double-confirm for system apps
    if [ "$safety_level" = "system" ]; then
        read -p "Are you REALLY sure you want to remove $display_name? This is a core system app. (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Skipping $display_name removal."
            echo
            return 0
        fi
    fi
    
    # Remove the main app
    sudo rm -rf "/Applications/$app_name.app"
    echo "Removed /Applications/$app_name.app"
    
    # Remove associated container files
    if [ -d "$HOME/Library/Containers/$bundle_id" ]; then
        rm -rf "$HOME/Library/Containers/$bundle_id"
        echo "Removed containers for $display_name"
    fi
    
    # Remove caches
    if [ -d "$HOME/Library/Caches/$bundle_id" ]; then
        rm -rf "$HOME/Library/Caches/$bundle_id"
        echo "Removed caches for $display_name"
    fi
    
    # Remove application support files
    if [ -d "$HOME/Library/Application Support/$app_name" ]; then
        rm -rf "$HOME/Library/Application Support/$app_name"
        echo "Removed application support files for $display_name"
    fi
    
    # Remove preferences
    if [ -f "$HOME/Library/Preferences/$bundle_id.plist" ]; then
        rm -f "$HOME/Library/Preferences/$bundle_id.plist"
        echo "Removed preferences for $display_name"
    fi
    
    echo "$display_name has been removed."
    echo
}

# Entertainment apps (generally safe to remove)
echo "========================================================"
echo "Entertainment Applications"
echo "These apps can be safely removed without affecting system functionality."
echo

# Chess
remove_app "Chess" "com.apple.Chess" "Chess" "safe"

# Photo Booth
remove_app "Photo Booth" "com.apple.Photo-Booth" "Photo Booth" "safe"

# Stickies
remove_app "Stickies" "com.apple.Stickies" "Stickies" "safe"

# Books
remove_app "Books" "com.apple.Books" "Books" "safe"

# Apple TV
remove_app "TV" "com.apple.TV" "Apple TV" "safe"

# Podcasts
remove_app "Podcasts" "com.apple.podcasts" "Podcasts" "safe"

# Productivity apps (use with some caution)
echo "========================================================"
echo "Productivity & Utility Applications"
echo "These apps can generally be removed, but some macOS features may use them."
echo

# Calculator
remove_app "Calculator" "com.apple.calculator" "Calculator" "safe"

# Voice Memos
remove_app "Voice Memos" "com.apple.VoiceMemos" "Voice Memos" "safe"

# Stock information apps (safe to remove)
echo "========================================================"
echo "Content & Information Applications"
echo "These apps provide content but aren't essential to system functionality."
echo

# News
remove_app "News" "com.apple.news" "Apple News" "safe"

# Stocks
remove_app "Stocks" "com.apple.stocks" "Stocks" "safe"

# Maps
remove_app "Maps" "com.apple.Maps" "Maps" "caution"

# Home automation
remove_app "Home" "com.apple.Home" "Home" "caution"

# Core system apps (not recommended to remove)
echo "========================================================"
echo "Core System Applications"
echo "These apps are more deeply integrated with macOS. Removal is not recommended."
echo "Only proceed if you understand the potential consequences."
echo

# Calendar
remove_app "Calendar" "com.apple.iCal" "Calendar" "system"

# Contacts
remove_app "Contacts" "com.apple.AddressBook" "Contacts" "system"

# FaceTime
remove_app "FaceTime" "com.apple.FaceTime" "FaceTime" "system"

# Find My
remove_app "Find My" "com.apple.findmy" "Find My" "system"

# Reminders
remove_app "Reminders" "com.apple.reminders" "Reminders" "system"

echo "Removal of selected applications complete."
