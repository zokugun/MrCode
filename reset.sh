#!/bin/bash

cd vscodium || exit

git add .
git reset --hard HEAD

rm -rf VSCode*
rm -rf vscode

cd ..
