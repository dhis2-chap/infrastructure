#!/bin/bash


#This file will first install LXD on the machine, before launching CHAP Core
# Install LXD

# Clone the infrastructure repository, this will be used to deploy CHAP Core lxd container
cd "$(dirname "$0")"

bash ./install-lxd.sh

bash ./deploy-chap-core.sh
