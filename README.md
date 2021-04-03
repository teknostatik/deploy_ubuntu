# deploy_ubuntu

Scripts for installing Ubuntu on new machines. It's based around my workflow, but might contain a few useful ideas for other people. Also includes scrips for building Multipass containers for various functions and a stripped down version of [updateall](https://github.com/teknostatik/updateall) for containers.

What this breaks down to is:

* `deploy_ubuntu` - script to run directly after installing Ubuntu (or Lubuntu) to add the software I use regularly.
* `deploy_privacy.sh` - script to build a multipass container and then call `deploy_ubuntu_privacy.sh` to build a tor-based setup
* `deploy_ubuntu_wsl.sh` - script for installing a minimal graphical desktop in a Multipass container 
* `updateall` - stripped down update script for multipass containers 



