#!/bin/bash

# Script to add apps I use to a Cubic build (debs only, no snaps)
# I test this on Ubuntu desktop and server (no flavours)
# Updated for 22.02 LTS

echo "--------------------------------------------------------"
echo "Script to add software to Cubic builds - v1.1 March 2022"
echo "--------------------------------------------------------"

# Standard error mitigation

set -euo pipefail

# Update software

sudo apt update
sudo apt upgrade -y

# Install the i3 window manager and some basic utilities

sudo apt install -y i3 i3blocks feh arandr git curl byobu synaptic xautolock shellcheck barrier kitty zathura pcmanfm firefox xinit inxi needrestart polybar scrot htop apt-transport-https blueman

# Install everything needed for Tor

sudo apt install -y torbrowser-launcher onionshare

# ProtonVPN installation

wget https://protonvpn.com/download/protonvpn-stable-release_1.0.1-1_all.deb
sudo apt install -y ./protonvpn-stable-release_1.0.1-1_all.deb
sudo apt-get update
sudo apt-get install -y protonvpn-cli protonvpn

# Download a custom update script

wget https://raw.githubusercontent.com/teknostatik/updateall/master/updateall
sudo mv updateall /usr/local/bin/
sudo chmod 755 /usr/local/bin/updateall

# Install some packages to make remote shells more interesting

sudo apt install -y neofetch fortune-mod cowsay

# Install the applications I use for converting text

sudo apt install -y pandoc texlive texlive-latex-extra

# Install some desktop applications for creating, editing and playing common media types

sudo apt install -y gimp youtube-dl rhythmbox vlc transmission kdenlive
sudo add-apt-repository ppa:obsproject/obs-studio -y
sudo apt install -y obs-studio
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install -y spotify-client

# Install Brave

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

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

# Manual steps are to install Teams, Zoom, Chrome, Brave and anything else non-free if required
# My image includes all these; you may not want them though

# Set up the post install script ready to run after initial login
# This will install snaps and anything else that requires being logged in to install

wget https://raw.githubusercontent.com/teknostatik/deploy_ubuntu/main/post_install.sh
sudo mv post_install.sh /usr/local/bin/
sudo chmod 755 /usr/local/bin/post_install.sh

echo "The script has now finished running."
