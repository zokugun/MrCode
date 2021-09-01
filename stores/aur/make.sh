#!/bin/bash

set -e

yay -Syu --noconfirm nodejs-lts-fermium npm

mkdir ~/.npm-global

npm config set prefix '~/.npm-global'

export PATH=~/.npm-global/bin:$PATH

makepkg --noconfirm -s -c
