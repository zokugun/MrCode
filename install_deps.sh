#!/bin/bash

if [[ "$OS_NAME" == "osx" ]]; then
  brew update
  brew install gnu-sed
fi