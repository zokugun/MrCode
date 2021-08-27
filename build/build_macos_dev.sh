#!/bin/bash

set -o allexport; source .env; set +o allexport

cd vscodium

gsed -i -E 's/\. prepare\_vscode\.sh/# . prepare_vscode.sh/g' build.sh

SHOULD_BUILD=yes CI_BUILD=no OS_NAME=osx VSCODE_ARCH=x64 RELEASE_VERSION='1.57.1' . build.sh
