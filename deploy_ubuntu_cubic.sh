#!/bin/bash

# Script to add apps I use to a Cubic build (debs only, no snaps)
echo "------------------------------------------------------"
echo "Script to add software to Cubic builds - v0.2 May 2021"
echo "------------------------------------------------------"

# Changelog:
# 25/4/21 - Created script
# 1/5/21 - Removed some apps that have lots of dependencies

# Standard error mitigation

set -euo pipefail

# Update software

sudo apt update
sudo apt upgrade -y

# Install the i3 window manager and some basic utilities

sudo apt install -y i3 i3blocks feh arandr curl byobu synaptic xautolock shellcheck barrier kitty zathura pcmanfm featherpad firefox

# Install everything needed for ProtonVPN and Tor
# See https://protonvpn.com/support/linux-vpn-tool/ for how to install

sudo apt install -y openvpn dialog python3-pip python3-setuptools torbrowser-launcher onionshare
sudo pip3 install protonvpn-cli

# Download a custom update script

wget https://raw.githubusercontent.com/teknostatik/updateall/master/updateall
sudo mv updateall /usr/local/bin/
sudo chmod 755 /usr/local/bin/updateall

# Install some packages to make remote shells more interesting and then add them to the profile for the logged in user

sudo apt install -y neofetch fortune-mod cowsay

# Install the applications I use for converting text

sudo apt install -y pandoc texlive texlive-latex-extra

# Install some desktop applications for creating, editing and playing common media types

sudo apt install -y gimp youtube-dl rhythmbox vlc brasero sound-juicer transmission
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install -y spotify-client

# Download and install Dropbox

sudo apt install -y nautilus-dropbox

# Set up i3. Comment this out if you want to use your own config file or build your config from scratch. You will need to point to a more sensible location for wallpaper.

wget https://raw.githubusercontent.com/teknostatik/i3_config/main/config
sudo mv config /etc/i3/

echo "The script has now finished running."
