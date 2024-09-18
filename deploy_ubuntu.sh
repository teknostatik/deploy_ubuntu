#!/bin/bash

# Script to run after installing Ubuntu from the desktop iso (with or without additional apps).
# Comment out any sections that don't interest you.

echo "------------------------------------------"
echo "General purpose Ubuntu installation script"
echo "------------------------------------------"

# Standard error mitigation

set -euo pipefail

# Add repositories

sudo add-apt-repository restricted universe multiverse

# Remove some things we don't need

sudo apt remove -y gnome-games
sudo apt autoremove -y

# Update software

sudo apt update
sudo apt -y upgrade

# Install some basic utilities

sudo apt install -y \
    htop \
    git \
    byobu \
    synaptic \
    shellcheck \
    zathura \
    rsync \
    curl \
    build-essential \
    gimp \
    rhythmbox \
    vlc \
    brasero \
    sound-juicer \
    lxappearance \
    flameshot \
    pandoc \
    texlive \
    texlive-latex-extra \
    abiword \
    remmina \
    xrdp \
    openssh-server \
    barrier \
    kitty \
    imagemagick \
    caffeine \
    pcmanfm \
    eza

# Download and install a custom update script

sudo wget https://raw.githubusercontent.com/teknostatik/updateall/master/updateall -O /usr/local/bin/updateall
sudo chmod 755 /usr/local/bin/updateall

# Install some packages to make remote shells more interesting and then add them to the profile for the logged in user

## Define variables
FF_VERSION="2.24.0"
FF_URL="https://github.com/fastfetch-cli/fastfetch/releases/download/${FF_VERSION}/fastfetch-linux-amd64.deb"
TEMP_DEB="$(mktemp)" # Create a temporary file for the .deb download

## Download and install Fastfetch
wget -qO "$TEMP_DEB" "$FF_URL"
sudo dpkg -i "$TEMP_DEB"
rm -f "$TEMP_DEB" # Clean up temporary .deb file

## Install fortune and cowsay
sudo apt-get update
sudo apt-get install -y fortune-mod cowsay

## Add commands to .profile if they don't already exist
PROFILE="$HOME/.profile"
grep -qxF 'echo; fortune | cowsay; echo' "$PROFILE" || echo 'echo; fortune | cowsay; echo' >> "$PROFILE"
grep -qxF 'echo; fastfetch; echo' "$PROFILE" || echo 'echo; fastfetch; echo' >> "$PROFILE"

# Add some aliases
echo "alias ls='eza -la'" >> /home/$USER/.bashrc
echo "alias top='htop'" >> /home/$USER/.bashrc

# Some optional packages, which users can choose to install

# Function to install vscode
install_vscode() {
    sudo apt-get install -y gpg
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/packages.microsoft.gpg > /dev/null
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    sudo apt-get install -y apt-transport-https
    sudo apt-get update
    sudo apt-get install -y code
}

# Function to install and configure i3
install_i3() {
    git clone https://github.com/teknostatik/i3_config.git
    cd i3_config
    chmod 755 install_i3.sh
    ./install_i3.sh
    cd
}

# Function to install tor
install_tor() {
    sudo apt-get install -y torbrowser-launcher onionshare
}

# Function to install DisplayLink
install_displaylink() {
    git clone https://github.com/AdnanHodzic/displaylink-debian.git
    cd displaylink-debian
    sudo ./displaylink-debian.sh
    wget -q https://raw.githubusercontent.com/teknostatik/debian/master/20-displaylink.conf -O /etc/X11/xorg.conf.d/20-displaylink.conf
    cd ..
}

# Function to install Flatpak
install_flatpak() {
    sudo apt-get install -y flatpak gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

# Function to install ProtonVPN
install_protonvpn() {
    wget -q https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.4_all.deb -O /tmp/protonvpn.deb
    sudo dpkg -i /tmp/protonvpn.deb
    sudo apt-get update
    sudo apt-get install -y proton-vpn-gnome-desktop
    rm /tmp/protonvpn.deb
}

# Function to install Zerotier 
install_zerotier() {
    curl -s https://install.zerotier.com | sudo bash
}

# Function to install Unixbench
install_unixbench() {
    sudo apt install -y libx11-dev libgl1-mesa-dev libxext-dev perl perl-modules make git
    git clone https://github.com/kdlucas/byte-unixbench.git
# uncomment tne next 2 lines to run the benchmark now
# cd byte-unixbench/UnixBench/
# ./Run
}

# Fuction to install Dropbox
install_dropbox() {
    sudo apt install -y nautilus-dropbox
    dropbox start -i
}

# Function to install Multipass
install_multipass() {
    sudo snap install multipass --classic
}

# Fuctiona to install Parabolic
install_parabolic() {
    sudo snap install tube-converter
}

# Function to install and configure Git
install_git() {
    sudo apt install -y git
    echo "We are now going to configure git"
    read -p "Enter your full name: " fullname
    read -p "Enter your email address: " email
    git config --global user.name "$fullname"
    git config --global user.email "$email"
    # Display the configured settings for git
    echo "Git has been configured with the following details:"
    git config --global --get user.name
    git config --global --get user.email
}

# Function to install non-free codecs and fonts
install_nonfree() {
    sudo apt install -y \
    ttf-mscorefonts-installer \
    ubuntu-restricted-extras
}

# Prompt function
prompt_install() {
    read -p "Do you want to install $1? (yes/no): " choice
    if [[ "$choice" == "yes" ]]; then
        $2
    fi
}

# Main script to prompt user and call installation functions
prompt_install "Visual Studio Code" install_vscode
prompt_install "i3 tiling window manager" install_i3
prompt_install "Tor browser and Onionshare" install_tor
prompt_install "DisplayLink docking station support" install_displaylink
prompt_install "Flatpak" install_flatpak
prompt_install "ProtonVPN" install_protonvpn
prompt_install "Zerotier" install_zerotier
prompt_install "Unixbench" install_unixbench
prompt_install "Multipass" install_multipass
prompt_install "Dropbox" install_dropbox
prompt_install "Parabolic" install_parabolic
prompt_install "and configure Git" install_git
prompt_install "Non-free codecs and fonts" install_nonfree

echo "The script has now finished running."
