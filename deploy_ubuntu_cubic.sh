#!/bin/bash

# Script to add apps I use to a Cubic build (debs only, no snaps)
echo "------------------------------------------------------"
echo "Script to add software to Cubic builds - v0.3 May 2021"
echo "------------------------------------------------------"

# Changelog:
# 25/4/21 - Created script
# 1/5/21 - Removed some apps that have lots of dependencies
# 3/5/21 - Added wallpaper (and moved save location for wallpaper to /usr/share/wallpaper)

# Standard error mitigation

set -euo pipefail

# Update software

sudo apt update
sudo apt upgrade -y

# Install the i3 window manager and some basic utilities

sudo apt install -y i3 i3blocks feh arandr curl byobu synaptic xautolock shellcheck barrier kitty zathura pcmanfm featherpad firefox xinit network-manager lxde

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

# Set up i3. Comment this out if you want to use your own config file or build your config from scratch.

wget https://raw.githubusercontent.com/teknostatik/i3_config/main/config
sudo mv config /etc/i3/

# Set up i3 wallpaper

mkdir /usr/share/wallpaper
cd /usr/share/wallaper
sudo wget https://www.dropbox.com/s/0yg8txbgw0ifqmg/9dy0gvxq7fl61.png
sudo wget https://www.dropbox.com/s/mtlzx6v4hlf8x2p/73hkbyuzk0p41.png
sudo wget https://www.dropbox.com/s/j9mmfedrc8r9zba/231-2311974_big.jpg
sudo wget https://www.dropbox.com/s/nlvt4x7n8yuxnd2/alena-aenami-away-1k.jpg
sudo wget https://www.dropbox.com/s/ujqf1rpmdphcs1x/uwp825694.jpeg
sudo wget https://www.dropbox.com/s/95lox8xzvh7l6me/wp5458622-stardew-valley-desktop-wallpapers.png
sudo wget https://www.dropbox.com/s/c8n7m3i2ruc84br/115104751-1a10a380-9f20-11eb-95b0-8950ac6381f0.png
sudo wget https://www.dropbox.com/s/tpq9v8lpwi753en/akira-in-city-4k-v0-1680x1050.jpg
cd
wget https://raw.githubusercontent.com/teknostatik/i3_config/main/randomise_wallpaper
sudo mv randomise_wallpaper /usr/local/bin/
sudo chmod 755 /usr/local/bin/randomise_wallpaper

# Set up the post install script ready to run after initial login

wget https://raw.githubusercontent.com/teknostatik/deploy_ubuntu/main/post_install.sh
sudo mv post_install.sh /usr/local/bin/
sudo chmod 755 /usr/local/bin/post_install.sh 

echo "The script has now finished running."
