#!/usr/bin/env bash
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
