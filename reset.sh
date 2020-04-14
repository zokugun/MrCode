#!/bin/bash

cd vscodium

git add .
git reset --hard HEAD

rm -rf VSCode*

cd vscode

git add .
git reset --hard HEAD

rm -rf .build out*