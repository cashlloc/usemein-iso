#!/usr/bin/env bash

source src/checks.sh

CONFIG=config.yaml

# Building config.yaml from configs/
cat configs/* >> $CONFIG

CLEAN=$(yq -r '.clean' $CONFIG)

# Sources $arch from profiledef.sh
arch=$(grep arch ./profiledef.sh | cut -d'"' -f 2)

# Creates packages.$arch
cat pkgs/* > packages.$arch

# Sets root password to rootpw from config.yaml.
# If left empty, password-less login is enabled for root
jinja2 airootfs/etc/shadow.j2 $CONFIG -o airootfs/etc/shadow

# Create ISO
mkarchiso -v .

#Cleaning up
if  $CLEAN; then
	rm -rf work/
fi
rm packages.$arch
rm config.yaml
deactivate
