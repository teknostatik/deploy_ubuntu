#!/bin/bash

# Script to run after installing Ubuntu from the desktop iso (with or without additional apps).
# Comment out any sections that don't interest you.

echo "-----------------------------------------------------------"
echo "General purpose Ubuntu installation script - v1.8, May 2021"
echo "-----------------------------------------------------------"

# Standard error mitigation

set -euo pipefail

# Update software

sudo apt update
sudo apt -y upgrade

# Install the i3 window manager and some basic utilities

sudo apt install -y i3 i3blocks feh arandr curl byobu synaptic xautolock shellcheck barrier kitty zathura remmina pcmanfm qutebrowser lxde featherpad ranger irssi zsh hexchat
sudo add-apt-repository ppa:agornostal/ulauncher -y
sudo apt install -y ulauncher

# Install some snaps

sudo snap install multipass --classic
sudo snap install bpytop
sudo snap install unixbench

# Install everything needed for ProtonVPN and Tor
# See https://protonvpn.com/support/linux-vpn-tool/ for how to install

sudo apt install -y openvpn dialog python3-pip python3-setuptools torbrowser-launcher onionshare
sudo pip3 install protonvpn-cli
sudo protonvpn init

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

sudo apt install -y gimp youtube-dl rhythmbox vlc brasero sound-juicer transmission kdenlive
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install -y spotify-client
sudo add-apt-repository ppa:obsproject/obs-studio -y
sudo apt install -y obs-studio

## Add some aliases

echo "alias ls='ls -la'" >> .bashrc
echo "alias mp='multipass list'" >> .bashrc
echo "alias top='bpytop'" >> .bashrc
echo "alias ls='ls -la'" >> .zshrc
echo "alias mp='multipass list'" >> .zshrc
echo "alias top='bpytop'" >> .zshrc

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

mkdir ~/.ssh/multipassKey
sudo cp /var/snap/multipass/common/data/multipassd/ssh-keys/id_rsa ~/.ssh/multipassKey/id_rsa
sudo chown $USER -R ~/.ssh/multipassKey

# Download and install Dropbox

sudo apt install -y nautilus-dropbox
dropbox start -i

# Set up i3. Comment this out if you want to use your own config file or build your config from scratch.

wget https://raw.githubusercontent.com/teknostatik/i3_config/main/config
sudo mv config ~/.config/i3/config

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

echo "The script has now finished running."
