#!/bin/bash

if [ -d "vscodium" ]; then
    cd vscodium

    git add .
    git reset --hard HEAD

    rm -rf VSCode*
    rm -rf vscode

    cd ..
fi
