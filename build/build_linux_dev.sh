#!/bin/bash

set -e

if [ -f .env ];
then
    set -o allexport
    source .env
    set +o allexport
fi

cd vscodium

gsed -i -E 's/\. prepare\_vscode\.sh/# . prepare_vscode.sh/g' build.sh

SHOULD_BUILD=yes CI_BUILD=no OS_NAME=linux VSCODE_ARCH=x64 LATEST_MS_COMMIT='1.58.2' . build.sh
