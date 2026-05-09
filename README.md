# Ubuntu Deployment Scripts

Scripts for setting up Ubuntu desktops, servers, and test containers. The main installer is interactive, so it can be used for both minimal and full desktop installs without needing separate scripts for every combination.

## What's included

* `deploy_ubuntu.sh` - the main post-install script for Ubuntu desktop or server installs. It adds baseline utilities, updates the system, installs `updateall`, and then prompts for optional software such as VS Code, Kitty, i3, Sway, Flatpak, ProtonVPN, Zerotier, Multipass, Spotify, UFW, QMK, DisplayLink, GearLever, Deskflow, Dropbox, and more.
* `deploy_ubuntu_cubic.sh` - a Cubic-oriented variant for building custom Ubuntu images. It focuses on apt/deb packages and skips snaps.
* `mp.sh` - a Multipass helper that builds a small set of Ubuntu test containers, including current LTS and development images.
* `smartinstall.sh` - a package helper that tries apt first, then snap, then flatpak.
* `updateall` - a lightweight update script for containers and other small Ubuntu installs.

## Usage

Run the main installer after a fresh Ubuntu install:

```bash
chmod +x deploy_ubuntu.sh
./deploy_ubuntu.sh
```

You can answer `no` to optional prompts if you want a lean command-line system. `Zerotier` is usually the one optional component that still makes sense on a minimal machine.

For a Cubic build, run `deploy_ubuntu_cubic.sh` inside your Cubic environment.

For container experiments, use `mp.sh` to build the Multipass instances, and `updateall` inside those containers when you just want a quick update pass.

## Notes

The scripts assume a fairly standard Ubuntu environment and use `sudo` for system changes. They have been used on recent Ubuntu releases, including 20.04, 22.04, 24.04, and 24.10.
