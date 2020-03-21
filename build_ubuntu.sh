#!/bin/bash

./get_repo.sh

./prepare.sh

cd vscodium || exit

SHOULD_BUILD=yes CI_BUILD=no BUILDARCH=x64 ./build.sh