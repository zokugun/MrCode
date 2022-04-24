#!/bin/bash

if [[ "$OS_NAME" == "osx" ]]; then
    if [[ "$CI_BUILD" == "no" ]]; then
        brew update
    fi

    brew install gnu-sed
fi
