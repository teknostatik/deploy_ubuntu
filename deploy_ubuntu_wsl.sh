#!/bin/bash

# Script to run afer installing Ubuntu WSL from the Windows app store. Comment out any sections that don't interest you.
# Also works with Multipass (normal containers, not Ubuntu Core)
echo "--------------------------------------------------------------------"
echo "Ubuntu configuration script for WSL and Multipass - v0.3, March 2021"
echo "--------------------------------------------------------------------"

# Changelog:
# 16/5/20 - Commented out text editing sofware
# 14/3/21 - Added some graphical apps and tidied up

# Update software

sudo apt update

# Install some basic utilities

sudo apt install -y byobu xrdp gnome-session kitty firefox pcmanfm

# Download a custom update script and then use it to get software updates and do some cleaning up

wget https://raw.githubusercontent.com/teknostatik/deploy_ubuntu/main/updateall
sudo mv updateall /usr/local/bin/
sudo chmod 755 /usr/local/bin/updateall
updateall

# Install some packages to make remote shells more interesting and then add them to the profile

sudo apt install -y neofetch fortune-mod cowsay
echo "echo; fortune | cowsay;echo" >> .profile
echo "echo; neofetch;echo" >> .profile

# Install bashtop - may fail on older verisons

sudo snap install bashtop

# Set some aliases

echo "alias ls='ls -la'" >> .bashrc
echo "alias top='bashtop'" >> .bashrc

# Set a password so we can use RDP

sudo passwd ubuntu
