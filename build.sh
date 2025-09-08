#!/usr/bin/env bash

source src/checks.sh
source src/render_jinja2.sh

CONFIG=config.yaml

# Building config.yaml from configs/
cat configs/* >> $CONFIG

CLEAN=$(yq -r '.clean' $CONFIG)

# Sources $arch from profiledef.sh
arch=$(grep arch ./profiledef.sh | cut -d'"' -f 2)

# Creates packages.$arch
cat pkgs/* > packages.$arch

# Render jinja templates
render_j2_tree . $CONFIG

# Create ISO
mkarchiso -v .

#Cleaning up
if  $CLEAN; then
	rm -rf work/
fi
rm packages.$arch
rm config.yaml
deactivate
