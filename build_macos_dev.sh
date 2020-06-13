#!/bin/bash

set -o allexport; source .env; set +o allexport

cd vscodium

gsed -i -E 's/\.\/prepare\_vscode\.sh/# .\/prepare_vscode.sh/g' build.sh

SHOULD_BUILD=yes CI_BUILD=no TRAVIS_OS_NAME=osx LATEST_MS_COMMIT='1.46.0'. build.sh