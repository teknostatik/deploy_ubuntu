# Ubuntu deployment scripts

Scripts for installing Ubuntu on new machines. It's based around my workflow, but might contain a few useful ideas for other people. Also includes scrips for building Multipass containers for various functions and a stripped down version of [updateall](https://github.com/teknostatik/updateall) for containers.

What this breaks down to is:

* `deploy_ubuntu.sh` - script to run directly after installing Ubuntu (or Lubuntu) to add the software I use regularly. This include the i3 WM and a lot of text editing/multimedia applications.
* `deploy_privacy.sh` - script to build a Multipass container and then call `deploy_ubuntu_privacy.sh` to build a tor-based setup
* `deploy_ubuntu_wsl.sh` - script for installing a minimal graphical desktop in a Multipass container
* `updateall` - stripped down update script for Multipass containers
* `mp.sh` - script to build a collection of Multipass containers for testing on different versions of Ubuntu
* `deploy_ubuntu_cubic.sh` to automate my setup using Cubic to build the iso and `post_install.sh` to run directly afterwards to pull in snaps and other local configuration.

Installation is fairly simple. Either build an iso using `deploy_ubuntu_cubic.sh` or run `deploy_ubuntu.sh` on a standard Ubuntu install (tested on latest LTS and latest non-LTS versions - desktop and server).

All of these scripts are under fairly active development. I do like to tweak things a lot.
