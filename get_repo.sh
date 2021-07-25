#!/bin/bash

if [ -d vscodium ];
then
  cd vscodium

  git fetch --all
else
  git clone https://github.com/VSCodium/vscodium.git

  cd vscodium
fi

# export LATEST_VSCODIUM_COMMIT=$(git rev-list --tags --max-count=1)
# export LATEST_VSCODIUM_TAG=$(git describe --tags ${LATEST_VSCODIUM_COMMIT})
# echo "Got the latest VSCodium tag: ${LATEST_VSCODIUM_TAG}"
# git checkout $LATEST_VSCODIUM_TAG

cd ..
