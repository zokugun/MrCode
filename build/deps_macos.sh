#!/bin/bash

exists() { type -t "$1" > /dev/null 2>&1; }

if ! exists jq;
then
	brew update
	brew install jq
fi

if ! exists gsed;
then
	brew update
	brew install gnu-sed
fi

if ! exists nvm;
then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
fi

nvm install v12