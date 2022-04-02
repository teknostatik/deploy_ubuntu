#!/bin/bash

# Script to run after installing Ubuntu from my custom Cubic build
# Most software will already be there - just need a few snaps

echo "-----------------------------------------------------------------"
echo "Ubuntu Cubic post-install configuration script - v0.2, March 2022"
echo "-----------------------------------------------------------------"

# Standard error mitigation

set -euo pipefail

# Install some snaps

sudo snap install multipass --classic

# Add some aliases

echo "alias ls='ls -la'" >> .bashrc
echo "alias mp='multipass list'" >> .bashrc
echo "alias top='htop'" >> .bashrc

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
# Syntax is ssh -X -i ~/.ssh/multipassKey/id_rsa ubuntu@container_ip_address

mkdir ~/.ssh/multipassKey
sudo cp /var/snap/multipass/common/data/multipassd/ssh-keys/id_rsa ~/.ssh/multipassKey/id_rsa
sudo chown andy -R ~/.ssh/multipassKey

# And now we should be done

echo "The script has now finished running."
