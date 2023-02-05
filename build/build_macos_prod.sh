#!/bin/bash

. reset.sh

if [ -f ".env" ]; then
    set -o allexport; source .env; set +o allexport
fi

UNAME_ARCH=$( uname -m )

if [[ "${UNAME_ARCH}" == "arm64" ]]; then
    export VSCODE_ARCH="arm64"
else
    export VSCODE_ARCH="x64"
fi

echo "-- VSCODE_ARCH: ${VSCODE_ARCH}"

. get_repo.sh

CI_BUILD=no . prepare.sh

# . version.sh

cd vscodium || exit

SHOULD_BUILD=yes CI_BUILD=no OS_NAME=osx . build.sh

# cd "VSCode-darwin-${VSCODE_ARCH}"

# codesign --deep --force --verbose --sign "$CERTIFICATE_OSX_ID" MrCode.app
