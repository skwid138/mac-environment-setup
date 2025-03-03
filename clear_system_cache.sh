#!/bin/bash
set -e

echo "====================================================="
echo "      System Cache Cleaning Utility"
echo "====================================================="
echo
echo "WARNING: This script will clear various cache files."
echo "While this is generally safe, it may affect performance temporarily"
echo "as applications and the system rebuild their caches."
echo

# Function to check disk space and report difference
check_space() {
    df -h / | grep -v Filesystem
}

# Store initial space
echo "Current disk space usage:"
check_space
echo

# Helper function to safely clear cache directories
clear_cache_dir() {
    local dir=$1
    local description=$2
    local use_sudo=$3
    
    echo "Checking $description..."
    
    if [ ! -d "$dir" ]; then
        echo "$description directory not found. Skipping."
        return
    fi
    
    read -p "Clear $description? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Count files before
        local count_before=0
        if [ "$use_sudo" = true ]; then
            count_before=$(sudo find "$dir" -type f | wc -l)
        else
            count_before=$(find "$dir" -type f | wc -l)
        fi

        echo "Found $count_before files in $description."
        
        # Delete contents but not the directory itself
        if [ "$use_sudo" = true ]; then
            sudo find "$dir" -mindepth 1 -delete
        else
            find "$dir" -mindepth 1 -delete
        fi
        
        echo "$description cleared successfully."
        check_space
    else
        echo "Skipping $description cleanup."
    fi
    echo
}

# Browser caches
echo "====================================================="
echo "Browser Caches"
echo "====================================================="
clear_cache_dir "$HOME/Library/Caches/com.apple.Safari" "Safari cache" false
clear_cache_dir "$HOME/Library/Safari/LocalStorage" "Safari local storage" false
clear_cache_dir "$HOME/Library/Caches/Google/Chrome" "Chrome cache" false
clear_cache_dir "$HOME/Library/Caches/com.microsoft.Edge" "Edge cache" false
clear_cache_dir "$HOME/Library/Caches/org.mozilla.firefox" "Firefox cache" false

# App development caches
echo "====================================================="
echo "Development Caches"
echo "====================================================="
clear_cache_dir "$HOME/Library/Developer/Xcode/DerivedData" "Xcode derived data" false
clear_cache_dir "$HOME/Library/Developer/CoreSimulator/Caches" "iOS simulator caches" false
clear_cache_dir "$HOME/Library/Caches/com.apple.dt.Xcode" "Xcode caches" false

# System caches (with caution)
echo "====================================================="
echo "System Caches"
echo "====================================================="
echo "These caches are generally safe to clear but will rebuild over time."

# Font caches
clear_cache_dir "/Library/Caches/com.apple.fontservice" "Font caches" true
clear_cache_dir "$HOME/Library/Caches/com.apple.FontRegistry" "Font registry cache" false

# App store and software update caches
clear_cache_dir "/Library/Caches/com.apple.appstore" "App Store cache" true
clear_cache_dir "$HOME/Library/Caches/com.apple.appstore" "User App Store cache" false

# System app caches (select ones that are safe to clear)
echo "====================================================="
echo "Application Caches"
echo "====================================================="
echo "Clearing these can free up space but may cause temporary slowdowns."

read -p "Would you like to clear application caches? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Only target known safe caches, not ALL caches
    echo "Clearing select application caches..."
    
    # System apps
    sudo find /Library/Caches -name "*.db" -delete 2>/dev/null || true
    
    # User apps (with exclusions for critical ones)
    find "$HOME/Library/Caches" -mindepth 1 -maxdepth 1 | grep -v "com.apple.dock" | grep -v "com.apple.finder" | while read cache_dir; do
        if [ -d "$cache_dir" ]; then
            app_name=$(basename "$cache_dir")
            echo "Clearing $app_name cache"
            rm -rf "$cache_dir"/* 2>/dev/null || true
        fi
    done
    
    echo "Application caches cleared."
    check_space
else
    echo "Skipping application caches."
fi

# Reset App Store download history cache
echo "====================================================="
echo "App Store Download History"
echo "====================================================="
read -p "Reset App Store download history cache? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    defaults delete com.apple.appstore DownloadHistoryItem 2>/dev/null || true
    killall "App Store" 2>/dev/null || true
    echo "App Store download history reset."
else
    echo "Skipping App Store history reset."
fi

# Clean up system logs
echo "====================================================="
echo "System Logs"
echo "====================================================="
read -p "Clear system logs? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo rm -rf /private/var/log/asl/*.asl 2>/dev/null || true
    sudo rm -rf /private/var/log/DiagnosticMessages/* 2>/dev/null || true
    echo "System logs cleared."
    check_space
else
    echo "Skipping system logs cleanup."
fi

# Final report
echo "====================================================="
echo "      Cache cleanup complete!"
echo "      Final disk space usage:"
check_space
echo "====================================================="
