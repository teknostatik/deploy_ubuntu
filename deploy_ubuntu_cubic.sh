#!/bin/bash

# Script to add apps I use to a Cubic build (debs only, no snaps)
# I test this on Ubuntu desktop and server (no flavours)

echo "------------------------------------------------------"
echo "Script to add software to Cubic builds - v0.3 May 2021"
echo "------------------------------------------------------"

# Standard error mitigation

set -euo pipefail

# Update software

sudo apt update
sudo apt upgrade -y

# Install the i3 window manager and some basic utilities

sudo apt install -y i3 i3blocks feh arandr git curl byobu synaptic xautolock tasksel shellcheck barrier kitty zathura pcmanfm featherpad firefox xinit network-manager lxde hexchat inxi needrestart
sudo add-apt-repository ppa:agornostal/ulauncher -y
sudo apt install -y ulauncher

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
# These are downloaded from various places. Will try and find credits at some point.

sudo mkdir /usr/share/wallpaper
cd /usr/share/wallpaper
sudo wget https://www.dropbox.com/s/65qlzytfq8c2thu/1920x1080.jpg
sudo wget https://www.dropbox.com/s/xtb4ybjwywzj5f3/3840x2160.png
sudo wget https://www.dropbox.com/s/f2rkmbv13c8t769/1920x1080-dark-linux.png
sudo wget https://www.dropbox.com/s/tc8ejnibiat49t6/5120x2880.png
sudo wget https://www.dropbox.com/s/uuh3exp1shb0h5o/IMG_8585-photivo-1-edit-crop-2160p.jpg
sudo wget https://www.dropbox.com/s/idk05cia43lj5qb/rocket.png
cd $HOME
wget https://raw.githubusercontent.com/teknostatik/i3_config/main/randomise_wallpaper
sudo mv randomise_wallpaper /usr/local/bin/
sudo chmod 755 /usr/local/bin/randomise_wallpaper
wget https://raw.githubusercontent.com/teknostatik/i3_config/main/lock.sh
sudo mv lock.sh /usr/local/bin/
sudo chmod 755 /usr/local/bin/lock.sh

# Let's replace the default Ubuntu wallpaper with a better background

sudo cp /usr/share/backgrounds/warty-final-ubuntu.png /usr/share/backgrounds/default.png
sudo cp /usr/share/wallpaper/1920x1080-dark-linux.png /usr/share/backgrounds/warty-final-ubuntu.png

# Manual steps are to install Teams, Zoom, Chrome, Brave and anything else non-free if required
# My image includes all these; you may not want them though

# Set up the post install script ready to run after initial login

wget https://raw.githubusercontent.com/teknostatik/deploy_ubuntu/main/post_install.sh
sudo mv post_install.sh /usr/local/bin/
sudo chmod 755 /usr/local/bin/post_install.sh

echo "The script has now finished running."
