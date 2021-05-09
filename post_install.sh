#!/bin/bash

# Script to run after installing Ubuntu from my custom Cubic build
# Most software will already be there - just need a few snaps
echo "------------------------------------------------------------"
echo "General purpose Ubuntu configuration script - v0.1, May 2021"
echo "------------------------------------------------------------"

# Standard error mitigation

set -euo pipefail

# Update software

# Install some snaps

sudo snap install multipass --classic
sudo snap install bpytop unixbench atom

# Set up ProtonVPN for the logged in user
# See https://account.protonvpn.com/account#openvpn for credentials
sudo protonvpn init

# Add some aliases

echo "alias ls='ls -la'" >> .bashrc
echo "alias mp='multipass list'" >> .bashrc
echo "alias top='bpytop'" >> .bashrc

# Build a container running the latest LTS for testing things on
#  This will work on machines with 8GB of ram without destroying your system, despite what it suggests

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
sudo chown andy -R ~/.ssh/multipassKey

# And now we should be done

echo "The script has now finished running."
