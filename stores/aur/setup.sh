#!/bin/bash

set -o errexit -o pipefail -o nounset

echo "Setting up ssh"

mkdir -p  ~/.ssh

ssh-keyscan -v -t ed25519 aur.archlinux.org >> ~/.ssh/known_hosts

cp ssh_config ~/.ssh

echo -e "${SSH_PRIVATE_KEY//_/\\n}" > ~/.ssh/aur

chmod -vR 600 ~/.ssh/aur*

ssh-keygen -vy -f ~/.ssh/aur > ~/.ssh/aur.pub

sha512sum ~/.ssh/aur ~/.ssh/aur.pub

echo "Test ssh"
ssh -Tv aur@aur.archlinux.org

echo "Setting up git"
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"
