#!/bin/sh

# Script to set up multipass and then deploy a load of containers for various things
echo "----------------------------------------------"
echo "Multipass Deployment Script - v0.4, April 2021"
echo "----------------------------------------------"

# Standard error mitigation

set -euo pipefail

# First off, install multipass:

sudo snap install multipass --classic

# What we're going to do next is:
# 1. Deploy a container for the current LTS version of Ubuntu
# 2. Run my usual post-deployment and update scripts inside that container
# 3. Shut the container down
# 4. Make this the primary container

multipass launch -m 8G -d 20G lts --name ubuntu-lts
multipass exec ubuntu-lts -- wget https://raw.githubusercontent.com/teknostatik/deploy_ubuntu/main/deploy_ubuntu_wsl.sh
multipass exec ubuntu-lts -- sudo mv deploy_ubuntu_wsl.sh /usr/local/bin/
multipass exec ubuntu-lts -- sudo chmod 755 /usr/local/bin/deploy_ubuntu_wsl.sh
multipass exec ubuntu-lts -- deploy_ubuntu_wsl.sh
multipass stop ubuntu-lts
multipass set client.primary-name=ubuntu-lts

# We will then do the same for the LTS before

multipass launch -m 8G -d 20G bionic --name ubuntu-lts-old
multipass exec ubuntu-lts-old -- wget https://raw.githubusercontent.com/teknostatik/deploy_ubuntu/main/deploy_ubuntu_wsl.sh
multipass exec ubuntu-lts-old -- sudo mv deploy_ubuntu_wsl.sh /usr/local/bin/
multipass exec ubuntu-lts-old -- sudo chmod 755 /usr/local/bin/deploy_ubuntu_wsl.sh
multipass exec ubuntu-lts-old -- deploy_ubuntu_wsl.sh
multipass stop ubuntu-lts-old

# Then we will follow the same process for the latest build of the next version of Ubuntu

multipass launch -m 8G -d 20G daily:21.04 --name ubuntu-devel
multipass exec ubuntu-devel -- wget https://raw.githubusercontent.com/teknostatik/deploy_ubuntu/main/deploy_ubuntu_wsl.sh
multipass exec ubuntu-devel -- sudo mv deploy_ubuntu_wsl.sh /usr/local/bin/
multipass exec ubuntu-devel -- sudo chmod 755 /usr/local/bin/deploy_ubuntu_wsl.sh
multipass exec ubuntu-devel -- deploy_ubuntu_wsl.sh
multipass stop ubuntu-devel

# Do the same for any other versions of Ubuntu you want but this is probably enough for a POC

# Next up let's try a snapcraft development and test environment. This bit needs work once I know more about it

multipass launch snapcraft:core20  --name snapcraft-build
multipass stop snapcraft-build
multipass launch core20 --name snapcraft-test
multipass stop snapcraft-test

# Finally let's see what we now have:

multipass list
