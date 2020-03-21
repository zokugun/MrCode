#!/bin/bash

./get_repo.sh

./prepare.sh

cd vscodium || exit

SHOULD_BUILD=yes BUILDARCH=x64 ./build.sh