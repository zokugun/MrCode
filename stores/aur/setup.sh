#!/bin/bash

set -o errexit -o pipefail -o nounset

echo "Setting up ssh"

mkdir -p  ~/.ssh

ssh-keyscan aur.archlinux.org >> ~/.ssh/known_hosts

cp ssh_config ~/.ssh

echo -e "${SSH_PRIVATE_KEY//_/\\n}" > ~/.ssh/aur

chmod 600 ~/.ssh/aur*

echo "Setting up git"
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"
