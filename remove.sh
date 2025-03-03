#!/bin/bash
set -e

# Make scripts executable
chmod +x remove_garageband.sh
chmod +x remove_iwork_suite.sh
chmod +x remove_imovie.sh
chmod +x remove_other_apps.sh
chmod +x clear_system_cache.sh

# Welcome message
echo "====================================================="
echo "      macOS Application Removal Utility"
echo "      This process will remove preinstalled apps"
echo "====================================================="
echo
echo "WARNING: This will permanently remove selected applications."
echo "Make sure you have a backup if you're unsure."
echo

# Function to display space usage before and after
check_space() {
    echo "Checking disk space usage..."
    df -h / | grep -v Filesystem
}

echo "Current disk space usage:"
check_space
echo

# GarageBand
echo "====================================================="
echo "GarageBand"
echo "====================================================="
echo "GarageBand can take up several GB of storage space."
echo "This includes sound libraries and instrument packs."
echo

if [ -d "/Applications/GarageBand.app" ]; then
    read -p "Do you want to remove GarageBand? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ./remove_garageband.sh
        check_space
    else
        echo "Skipping GarageBand removal."
    fi
else
    echo "GarageBand not found. Skipping."
fi
echo

# iWork Suite
echo "====================================================="
echo "iWork Suite (Pages, Numbers, Keynote)"
echo "====================================================="
echo "Apple's office productivity suite."
echo

if [ -d "/Applications/Pages.app" ] || [ -d "/Applications/Numbers.app" ] || [ -d "/Applications/Keynote.app" ]; then
    read -p "Do you want to check iWork apps for removal? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ./remove_iwork_suite.sh
        check_space
    else
        echo "Skipping iWork suite removal."
    fi
else
    echo "No iWork apps found. Skipping."
fi
echo

# iMovie
echo "====================================================="
echo "iMovie"
echo "====================================================="
echo "Apple's video editing application."
echo

if [ -d "/Applications/iMovie.app" ]; then
    read -p "Do you want to remove iMovie? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ./remove_imovie.sh
        check_space
    else
        echo "Skipping iMovie removal."
    fi
else
    echo "iMovie not found. Skipping."
fi
echo

# Other Apps
# echo "====================================================="
# echo "Other Preinstalled Applications"
# echo "====================================================="
# echo "This includes apps like Photo Booth, Chess, News, etc."
# echo "You'll be prompted for each app individually."
# echo

# read -p "Do you want to check other preinstalled apps for removal? (y/n) " -n 1 -r
# echo
# if [[ $REPLY =~ ^[Yy]$ ]]; then
#     ./remove_other_apps.sh
#     check_space
# else
#     echo "Skipping other apps removal."
# fi
# echo

# System Cache Cleanup
echo "====================================================="
echo "System Cache Cleanup"
echo "====================================================="
echo "This will clear system and application caches to free up space."
echo

read -p "Run system cache cleanup? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ./clear_system_cache.sh
else
    echo "Skipping system cache cleanup."
fi
echo

# Final cleanup
echo "====================================================="
echo "Final Cleanup"
echo "====================================================="
echo "This will empty the trash to recover disk space."
echo

read -p "Empty trash to recover disk space? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    osascript -e 'tell application "Finder" to empty trash'
    echo "Trash emptied."
    check_space
else
    echo "Skipping trash emptying."
fi
echo

echo "====================================================="
echo "      Removal process complete!"
echo "      Final disk space usage:"
check_space
echo "====================================================="
