#!/bin/bash

exists() { type -t "$1" > /dev/null 2>&1; }

sudo apt-get install libx11-dev libxkbfile-dev
sudo apt-get install libsecret-1-dev
sudo apt-get install fakeroot rpm

if ! exists python; then
	sudo apt install python
fi

if ! exists jq; then
	sudo apt-get install -y jq
fi

# if ! exists nvm; then
# 	wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
# fi

source ~/.nvm/nvm.sh

nvm install v12

# if ! hash yarn 2>/dev/null; then
# if ! exists yarn; then
#	npm install -g yarn
# fi