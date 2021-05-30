#!/bin/sh

# Minimal privacy-focused build of Ubuntu for containers
# This should also work on physical Ubuntu/Debian macines if you comment out the last line

echo "--------------------------------------------------------"
echo "Ubuntu configuration script for privacy - v0.2, May 2021"
echo "--------------------------------------------------------"

# Update software

sudo apt update

# Install some basic utilities

sudo apt install -y byobu xrdp gnome-session kitty torbrowser-launcher pcmanfm onionshare zathura htop


# Install everything needed for ProtonVPN
# See https://protonvpn.com/support/linux-vpn-tool/ for how to install

sudo apt install -y openvpn dialog python3-pip python3-setuptools
sudo pip3 install protonvpn-cli
sudo protonvpn init

# Download a custom update script and then use it to get software updates and do some cleaning up

wget https://raw.githubusercontent.com/teknostatik/deploy_ubuntu/main/updateall
sudo mv updateall /usr/local/bin/
sudo chmod 755 /usr/local/bin/updateall
updateall

# Install some packages to make remote shells more interesting and then add them to the profile

sudo apt install -y neofetch fortune-mod cowsay
echo "echo; fortune | cowsay;echo" >> .profile
echo "echo; neofetch;echo" >> .profile

# Set some aliases

echo "alias ls='ls -la'" >> .bashrc
echo "alias top='htop'" >> .bashrc

# Set a password so we can use RDP

sudo passwd ubuntu

echo "All done! Hope you have a nice day!"
