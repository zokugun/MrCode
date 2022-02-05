#!/bin/bash

set -e

if [ -f .env ];
then
    set -o allexport
    source .env
    set +o allexport
fi

. version.sh

sed -i -E 's/\. prepare\_vscode\.sh/# . prepare_vscode.sh/g' build.sh

SHOULD_BUILD=yes CI_BUILD=no OS_NAME=linux VSCODE_ARCH=x64 RELEASE_VERSION='1.64.0' . build.sh
