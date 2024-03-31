#!/bin/bash

# Script to run after installing Ubuntu from the desktop iso (with or without additional apps).
# Comment out any sections that don't interest you.

echo "------------------------------------------"
echo "General purpose Ubuntu installation script"
echo "------------------------------------------"

# Standard error mitigation

set -euo pipefail

# Get a new sources.list that will alow installation of everything in this script

https://raw.githubusercontent.com/teknostatik/deploy_ubuntu/main/sources.list
sudo mv sources.list /etc/apt/

# Update software

sudo apt update
sudo apt -y upgrade

# Install some basic utilities

sudo apt install -y git curl scrot byobu synaptic xautolock shellcheck barrier kitty zathura pcmanfm lxde featherpad tasksel inxi needrestart polybar htop apt-transport-https blueman ubuntu-restricted-extras

# Install and configure i3

wget https://raw.githubusercontent.com/teknostatik/i3_config/main/install_i3.sh
sudo mv install_i3.sh /usr/local/bin/
sudo chmod 755 /usr/local/bin/install_i3.sh
install_i3.sh

# Install some snaps

sudo snap install multipass --classic
sudo snap install unixbench
sudo snap install tube-converter

# Install Flatpak

sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# install vscode

# flatpak install flathub com.visualstudio.code -y

# or

sudo apt-get install gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt update
sudo apt install code

# Install everything needed for Tor

sudo apt install -y torbrowser-launcher onionshare

# Set up git

git config --global user.name "Andy Ferguson"
git config --global user.email "andy@teknostatik.org"

# install ProtonVPN

wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3-2_all.deb
sudo dpkg -i protonvpn-stable-release_1.0.3-2_all.deb
sudo apt update
sudo apt install -y proton-vpn-gnome-desktop

# Install Zerotier

curl -s https://install.zerotier.com | sudo bash

# Download and install a custom update script

wget https://raw.githubusercontent.com/teknostatik/updateall/master/updateall
sudo mv updateall /usr/local/bin/
sudo chmod 755 /usr/local/bin/updateall

# Install some packages to make remote shells more interesting and then add them to the profile for the logged in user

wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.8.7/fastfetch-linux-amd64.deb
sudo dpkg -i fastfetch-linux-amd64.deb
sudo apt install -y fortune-mod cowsay
echo "echo; fortune | cowsay;echo" >> .profile
echo "echo; fastfetch;echo" >> .profile

# Install the applications I use for writing, editing and previewing text

sudo apt install -y pandoc texlive texlive-latex-extra

# Install some desktop applications for creating, editing and playing common media types
# Some of these are quite large so you might want to comment them out

sudo apt install -y gimp rhythmbox vlc brasero sound-juicer transmission

# Add some aliases

echo "alias ls='ls -la'" >> .bashrc
echo "alias mp='multipass list'" >> .bashrc
echo "alias top='htop'" >> .bashrc

# Install drivers for Displaylink docking stations, such as the lenovo and Dell ones I use at home and work

git clone https://github.com/AdnanHodzic/displaylink-debian.git
cd displaylink-debian
sudo ./displaylink-debian.sh

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
