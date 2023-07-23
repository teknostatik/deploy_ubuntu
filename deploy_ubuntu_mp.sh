#!/bin/sh

# Script to run afer installing Multipass (normal containers, not Ubuntu Core)

echo "-----------------------------------------------------------"
echo "Ubuntu configuration script for Multipass - v0.9, July 2023"
echo "-----------------------------------------------------------"

# Update software

sudo apt update

# Install some basic utilities

sudo apt install -y byobu xrdp lxde kitty firefox pcmanfm htop

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
