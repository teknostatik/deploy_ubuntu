#!/bin/bash

# This script attempts to install a package using apt, snap, or flatpak in that order.
# It checks if the package is available in each package manager and installs it if found.
# Usage: ./smartinstall.sh <package-name>
# Make sure the script is run with root privileges
# or with sudo to allow installation of packages.
# Check if the script is run with root privileges

PACKAGE="$1"

if [[ -z "$PACKAGE" ]]; then
    echo "Usage: $0 <package-name>"
    exit 1
fi

echo "Trying to install '$PACKAGE' using apt..."
if apt-cache show "$PACKAGE" > /dev/null 2>&1; then
    sudo apt update
    sudo apt install -y "$PACKAGE"
    exit 0
fi

echo "'$PACKAGE' not found in apt. Trying snap..."
if snap find "$PACKAGE" | grep -q "$PACKAGE"; then
    sudo snap install "$PACKAGE"
    exit 0
fi

echo "'$PACKAGE' not found in snap. Trying flatpak..."
if flatpak search "$PACKAGE" | grep -q "$PACKAGE"; then
    echo "Found in Flatpak. Attempting installation..."
    # Assumes flathub is already added
    REF=$(flatpak search "$PACKAGE" --columns=application | grep "$PACKAGE" | head -n 1)
    if [[ -n "$REF" ]]; then
        sudo flatpak install -y flathub "$REF"
        exit 0
    fi
fi

echo "'$PACKAGE' is not available via apt, snap, or flatpak."
exit 1