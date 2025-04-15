# Ubuntu deployment scripts

Scripts for installing Ubuntu on new machines. It's based around my workflow, but might contain a few useful ideas for other people. Also includes scrips for building Multipass containers for various functions and a stripped down version of [updateall](https://github.com/teknostatik/updateall) for containers.

What this breaks down to is:

* `deploy_ubuntu.sh` - script to run directly after installing Ubuntu (desktop or server) to add the software I use regularly. 
* `updateall` - stripped down update script for Multipass containers
* `mp.sh` - script to build a collection of Multipass containers for testing on different versions of Ubuntu. 

Installation is fairly simple. Run `deploy_ubuntu.sh` on a standard Ubuntu install (tested on 20.04, 22.04, 24.04, 24.10).

There were various other scripts in this repository, but the main script should now be able to handle most scenarios, as the vast majority of software is optional. For a command-line only system, just answer "no" for all optional components, apart from Zerotier if you want to use it. 
