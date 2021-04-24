#!/bin/bash

# Script to run after installing Ubuntu from the desktop iso (with or without additional apps). Comment out any sections that don't interest you.
echo "--------------------------------------------------------------"
echo "General purpose Ubuntu configuration script - v1.7, April 2021"
echo "--------------------------------------------------------------"

# Changelog:
# 16/5/20 - Added Multipass
# 16/5/20 - Added Proton VPN
# 06/6/20 - Added some aliases
# 13/6/20 - Added arandr and brasero
# 16/6/20 - Added sound-juicer and transmission
# 28/6/20 - Added scripted build of a Multipass container
# 11/7/20 - General tidying up
# 19/7/20 - Reverted to non-snap version of Spotify (for stability) & changed wallpaper
# 23/7/20 - Changed order so multipass containers have downloaded before dropbox tries to sync files
# 18/9/20 - Removed anything not used regularly
# 27/9/20 - Enabled Multipass containers to run graphical applications
# 18/10/20 - Copied Multipass SSH keys to user account and added onionshare and shellcheck
# 18/1/21 - Added barrier, obs-studio and kdenlive
# 14/3/21 - Slight change of order and changed default container configuration to add more memory
# 3/4/21 - Removed setting i3 wallpaper. That's done in my i3 config file now. Also changed some links from dropbox to github
# 10/4/21 - Added zathura and removed tilix
# 16/4/21 - Removed anything QT based and replaced with GTK versions. Also added kitty, i3blocks, ranger and featherpad and removed gnome-session and gnome-tweak-tool
# 25/4/21 - Pulled in i3 config file from github - will need some edits for anyone who isn't me

# Standard error mitigation

set -euo pipefail

# Update software

sudo apt update
sudo apt upgrade -y

# Install the i3 window manager and some basic utilities

sudo apt install -y i3 i3blocks feh arandr curl byobu synaptic xautolock shellcheck barrier kitty zathura remmina pcmanfm featherpad ranger irssi zsh
sudo snap install multipass --classic
sudo snap install bashtop

# Install everything needed for ProtonVPN and Tor
# See https://protonvpn.com/support/linux-vpn-tool/ for how to install

sudo apt install -y openvpn dialog python3-pip python3-setuptools torbrowser-launcher onionshare
sudo pip3 install protonvpn-cli
sudo protonvpn init

# Download a custom update script

wget https://raw.githubusercontent.com/teknostatik/updateall/master/updateall
sudo mv updateall /usr/local/bin/
sudo chmod 755 /usr/local/bin/updateall

# Install some packages to make remote shells more interesting and then add them to the profile for the logged in user

sudo apt install -y neofetch fortune-mod cowsay
echo "echo; fortune | cowsay;echo" >> .profile
echo "echo; neofetch;echo" >> .profile

# Install the applications I use for writing, editing and previewing text

sudo snap install --classic atom
sudo apt install -y pandoc texlive texlive-latex-extra

# Install some desktop applications for creating, editing and playing common media types

sudo apt install -y gimp youtube-dl rhythmbox vlc brasero sound-juicer transmission kdenlive
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install -y spotify-client
sudo add-apt-repository ppa:obsproject/obs-studio -y
sudo apt install -y obs-studio

## Add some aliases

echo "alias ls='ls -la'" >> .bashrc
echo "alias mp='multipass list'" >> .bashrc
echo "alias top='bashtop'" >> .bashrc

## Build a container running the latest LTS for testing things on

multipass launch -m 8G -d 20G lts --name ubuntu-lts
multipass exec ubuntu-lts -- wget https://raw.githubusercontent.com/teknostatik/deploy_ubuntu/main/deploy_ubuntu_wsl.sh
multipass exec ubuntu-lts -- sudo mv deploy_ubuntu_wsl.sh /usr/local/bin/
multipass exec ubuntu-lts -- sudo chmod 755 /usr/local/bin/deploy_ubuntu_wsl.sh
multipass exec ubuntu-lts -- deploy_ubuntu_wsl.sh
multipass stop ubuntu-lts
multipass set client.primary-name=ubuntu-lts

## Enable that container (and any future ones) to run graphical apps

mkdir ~/.ssh/multipassKey
sudo cp /var/snap/multipass/common/data/multipassd/ssh-keys/id_rsa ~/.ssh/multipassKey/id_rsa
sudo chown andy -R ~/.ssh/multipassKey

# Download and install Dropbox

sudo apt install -y nautilus-dropbox
dropbox start -i

# Set up i3. Comment this out if you want to use your own config file or build your config from scratch. You will need to point to a more sensible location for wallpaper.

wget https://raw.githubusercontent.com/teknostatik/i3_config/main/config
sudo mv config /etc/i3/

echo "The script has now finished running."
