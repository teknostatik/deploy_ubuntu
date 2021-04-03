#!/bin/bash

# Deploy container for privacy
echo "-------------------------------------------"
echo "Deploy Private Container - v0.1, March 2021"
echo "-------------------------------------------"

# Changelog:
# 31/03/2021 - created

## Build a container running the latest development build for testing things on and make it primary
## You will want at least 16G of RAM and 100G of free disk space to make these settings sensible

multipass launch lts -m 8G -d 20G --name  privacy
multipass exec privacy -- wget https://www.dropbox.com/s/arzvvwugzx2op6z/deploy_ubuntu_privacy.sh
multipass exec privacy -- sudo mv deploy_ubuntu_privacy.sh /usr/local/bin/
multipass exec privacy -- sudo chmod 755 /usr/local/bin/deploy_ubuntu_privacy.sh
multipass exec privacy -- deploy_ubuntu_privacy.sh
multipass stop privacy
