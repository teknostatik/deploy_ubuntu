#!/bin/bash

# This script attempts to install a package using apt, snap, or flatpak in that order.
# It checks if the package is available in each package manager and installs it if found.
# Usage: ./smartinstall.sh <package-name>
# Make sure the script is run with root privileges
# or with sudo to allow installation of packages.
# Check if the script is run with root privileges

#!/bin/bash

PACKAGE="$1"

# Function to check if a command exists (is installed)
command_exists() {
  command -v "$1" > /dev/null 2>&1
}

# Check for package name argument
if [[ -z "$PACKAGE" ]]; then
    echo "Usage: $0 <package-name>"
    exit 1
fi

# Apt check
if command_exists apt; then
  echo "Trying to install '$PACKAGE' using apt..."
  if apt-cache show "$PACKAGE" > /dev/null 2>&1; then
      sudo apt update
      sudo apt install -y "$PACKAGE"
      exit 0
  fi
else
  echo "apt is not installed. Skipping."
fi

# Snap check
if command_exists snap; then
  echo "'$PACKAGE' not found in apt. Trying snap..."
  if snap find "$PACKAGE" | grep -q "$PACKAGE"; then
      sudo snap install "$PACKAGE"
      exit 0
  fi
else
  echo "snap is not installed. Skipping."
fi

# Flatpak check
if command_exists flatpak; then
  echo "'$PACKAGE' not found in snap. Trying flatpak..."
  if flatpak search "$PACKAGE" | grep -q "$PACKAGE"; then
      echo "Found in Flatpak. Attempting installation..."
      REF=$(flatpak search "$PACKAGE" --columns=application | grep "$PACKAGE" | head -n 1)
      if [[ -n "$REF" ]]; then
          sudo flatpak install -y flathub "$REF"
          exit 0
      fi
  fi
else
  echo "flatpak is not installed. Skipping."
fi

echo "'$PACKAGE' is not available via apt, snap, or flatpak."
exit 1
