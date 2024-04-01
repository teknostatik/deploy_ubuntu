#!/bin/bash

# Script to add apps I use to a Cubic build (debs only, no snaps)
# I test this on Ubuntu desktop and server (no flavours)
# Updated for 22.02 LTS

echo "--------------------------------------"
echo "Script to add software to Cubic builds"
echo "--------------------------------------"

# Standard error mitigation

set -euo pipefail

# Get a new sources.list that will allow installation of everything in this script
# Currently this is for version 23.10. If you're not running that, then this is not for you and you should comment out these lines.

https://raw.githubusercontent.com/teknostatik/deploy_ubuntu/main/sources.list
sudo mv /etc/apt/sources.list /etc/apt/sources.list_old
sudo mv sources.list /etc/apt/

# Update software

sudo apt update
sudo apt upgrade -y

# Install the i3 window manager and some basic utilities

sudo apt install -y i3 i3blocks feh arandr git curl byobu synaptic xautolock shellcheck barrier kitty zathura pcmanfm xinit inxi needrestart polybar scrot htop apt-transport-https blueman

# Install everything needed for Tor

sudo apt install -y torbrowser-launcher onionshare

# Download a custom update script

wget https://raw.githubusercontent.com/teknostatik/updateall/master/updateall
sudo mv updateall /usr/local/bin/
sudo chmod 755 /usr/local/bin/updateall

# Install some packages to make remote shells more interesting

wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.8.7/fastfetch-linux-amd64.deb
sudo dpkg -i fastfetch-linux-amd64.deb
sudo apt install -y fortune-mod cowsay

# Install the applications I use for converting text

sudo apt install -y pandoc texlive texlive-latex-extra

# Install some desktop applications for creating, editing and playing common media types

sudo apt install -y gimp rhythmbox vlc transmission

# Download and install Dropbox

sudo apt install -y nautilus-dropbox

# Set up i3. Comment this out if you want to use your own config file or build your config from scratch.

wget https://raw.githubusercontent.com/teknostatik/i3_config/main/config
sudo mv config /etc/i3/

# Set up i3 wallpaper

sudo mkdir /usr/share/wallpaper
sudo cp -R /usr/share/backgrounds/* /usr/share/wallpaper
wget https://raw.githubusercontent.com/teknostatik/i3_config/main/randomise_wallpaper
sudo mv randomise_wallpaper /usr/local/bin/
sudo chmod 755 /usr/local/bin/randomise_wallpaper
wget https://raw.githubusercontent.com/teknostatik/i3_config/main/lock.sh
sudo mv lock.sh /usr/local/bin/
sudo chmod 755 /usr/local/bin/lock.sh

# Install Flatpak

sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# install vscode

sudo apt-get install gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt update
sudo apt install code


# Manual steps are to install Teams, Zoom, Chrome, Brave and anything else non-free if required
# My image includes all these; you may not want them though

# Set up the post install script ready to run after initial login
# This will install snaps and anything else that requires being logged in to install

wget https://raw.githubusercontent.com/teknostatik/deploy_ubuntu/main/post_install.sh
sudo mv post_install.sh /usr/local/bin/
sudo chmod 755 /usr/local/bin/post_install.sh

echo "The script has now finished running."
