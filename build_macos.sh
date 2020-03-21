#!/bin/bash

./get_repo.sh

# cp -rp src/* vscodium/

./prepare.sh

cd vscodium || exit

SHOULD_BUILD=yes CI_BUILD=no TRAVIS_OS_NAME=osx ./build.sh