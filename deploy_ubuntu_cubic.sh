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

sudo apt install -y i3 i3blocks feh arandr curl byobu synaptic xautolock shellcheck barrier kitty zathura pcmanfm featherpad qutebrowser xinit network-manager lxde zsh
sudo add-apt-repository ppa:agornostal/ulauncher -y
sudo apt install -y ulauncher

# Install everything needed for ProtonVPN and Tor
# See https://protonvpn.com/support/linux-vpn-tool/ for how to install

sudo apt install -y openvpn dialog python3-pip python3-setuptools torbrowser-launcher onionshare
sudo pip3 install protonvpn-cli

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

mkdir /usr/share/wallpaper
cd /usr/share/wallpaper
sudo wget https://www.dropbox.com/s/0yg8txbgw0ifqmg/9dy0gvxq7fl61.png
sudo wget https://www.dropbox.com/s/j9mmfedrc8r9zba/231-2311974_big.jpg
sudo wget https://www.dropbox.com/s/cljxhezhxuu3nce/background.png
sudo wget https://www.dropbox.com/s/f2rkmbv13c8t769/1920x1080-dark-linux.png
sudo wget https://www.dropbox.com/s/1i7g8u5h6whd5dv/3430638.png
sudo wget https://www.dropbox.com/s/bkae9ethe3jqbod/jyrji9bnp3171.jpg
cd $HOME
wget https://raw.githubusercontent.com/teknostatik/i3_config/main/randomise_wallpaper
sudo mv randomise_wallpaper /usr/local/bin/
sudo chmod 755 /usr/local/bin/randomise_wallpaper

# Set up the post install script ready to run after initial login

wget https://raw.githubusercontent.com/teknostatik/deploy_ubuntu/main/post_install.sh
sudo mv post_install.sh /usr/local/bin/
sudo chmod 755 /usr/local/bin/post_install.sh

echo "The script has now finished running."
