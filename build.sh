#!/usr/bin/env bash

CONFIG=config.yaml

# Building config.yaml from configs/
cat configs/* >> $CONFIG

DEBUG=$(yq -r '.debug' $CONFIG)

# Checking if running user is root
if [[ $EUID -ne 0 ]]; then
	echo -e "​💥​ ​💥​ ​💥​ Not running as root. Exiting...​💥​ ​💥​ ​💥​"
	exit 1
fi

# Checking if yq is installed
if ! command -v yq > /dev/null 2>&1; then
	echo "Nope"
	exit 1
fi

#venv magic --> to be cleaned / optimized / upgraded 
if [[ -d ./venv ]]; then
	echo -e "😇​ ./venv found"
	source ./venv/bin/activate
else
	echo -e "🫨​ ./venv not found... creating it and installing requirements.txt"
	python3 -m venv ./venv
	source ./venv/bin/activate
	pip3 install -r ./requirements.txt
fi

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
if ! $DEBUG; then
	rm -rf work
fi
rm packages.$arch
rm config.yaml
deactivate
