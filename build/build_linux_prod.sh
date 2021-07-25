#!/bin/bash

set -e

. reset.sh

if [ -f .env ];
then
    set -o allexport
    source .env
    set +o allexport
fi

. get_repo.sh

CI_BUILD=no . prepare.sh

SHOULD_BUILD=yes CI_BUILD=no OS_NAME=linux VSCODE_ARCH=x64 . build.sh
