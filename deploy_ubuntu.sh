#!/bin/bash

# Script to run after installing Ubuntu from the desktop iso (with or without additional apps).
# Comment out any sections that don't interest you.

echo "---------------------------------------------------------------"
echo "General purpose Ubuntu installation script - v2.0.2, April 2022"
echo "---------------------------------------------------------------"

# Standard error mitigation

set -euo pipefail

# Update software

sudo apt update
sudo apt -y upgrade

# Install some basic utilities

sudo apt install -y git curl scrot byobu synaptic xautolock shellcheck barrier kitty zathura pcmanfm lxde featherpad tasksel inxi needrestart polybar htop apt-transport-https
sudo add-apt-repository ppa:agornostal/ulauncher -y
sudo apt install -y ulauncher

# Install and configure i3

wget https://raw.githubusercontent.com/teknostatik/i3_config/main/install_i3.sh
sudo mv install_i3.sh /usr/local/bin/
sudo chmod 755 /usr/local/bin/install_i3.sh
install_i3.sh

# Install Brave

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

# Install some snaps

sudo snap install multipass --classic
sudo snap install unixbench

# Install everything needed for Tor

sudo apt install -y torbrowser-launcher onionshare

# ProtonVPN installation

wget https://protonvpn.com/download/protonvpn-stable-release_1.0.1-1_all.deb
sudo apt install ./protonvpn-stable-release_1.0.1-1_all.deb
sudo apt-get update
sudo apt-get install -y protonvpn-cli protonvpn

# Download and install a custom update script

wget https://raw.githubusercontent.com/teknostatik/updateall/master/updateall
sudo mv updateall /usr/local/bin/
sudo chmod 755 /usr/local/bin/updateall

# Install some packages to make remote shells more interesting and then add them to the profile for the logged in user

sudo apt install -y neofetch fortune-mod cowsay
echo "echo; fortune | cowsay;echo" >> .profile
echo "echo; neofetch;echo" >> .profile

# Install the applications I use for writing, editing and previewing text

sudo snap install --classic atom
sudo apt install -y pandoc texlive texlive-latex-extra abiword

# Install some desktop applications for creating, editing and playing common media types
# Some of these are quite large so you might want to comment them out

sudo apt install -y gimp youtube-dl rhythmbox vlc brasero sound-juicer transmission
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install -y spotify-client
sudo add-apt-repository ppa:obsproject/obs-studio -y
sudo apt install -y obs-studio

## Add some aliases

echo "alias ls='ls -la'" >> .bashrc
echo "alias mp='multipass list'" >> .bashrc
echo "alias top='htop'" >> .bashrc

# Build a container running the latest LTS for testing things on
# This will work on a machine with 8GB of RAM, despite what it looks like

multipass launch -m 8G -d 20G lts --name ubuntu-lts
multipass exec ubuntu-lts -- wget https://raw.githubusercontent.com/teknostatik/deploy_ubuntu/main/deploy_ubuntu_wsl.sh
multipass exec ubuntu-lts -- sudo mv deploy_ubuntu_wsl.sh /usr/local/bin/
multipass exec ubuntu-lts -- sudo chmod 755 /usr/local/bin/deploy_ubuntu_wsl.sh
multipass exec ubuntu-lts -- deploy_ubuntu_wsl.sh
multipass stop ubuntu-lts
multipass set client.primary-name=ubuntu-lts

# Enable that container (and any future ones) to run graphical apps
# Syntax is ssh -X -i ~/.ssh/multipassKey/id_rsa ubuntu@container_ip_address

mkdir ~/.ssh/multipassKey
sudo cp /var/snap/multipass/common/data/multipassd/ssh-keys/id_rsa ~/.ssh/multipassKey/id_rsa
sudo chown $USER -R ~/.ssh/multipassKey

# Download and install Dropbox

sudo apt install -y nautilus-dropbox
dropbox start -i

echo "The script has now finished running."
