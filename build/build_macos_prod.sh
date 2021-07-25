#!/bin/bash

. reset.sh

set -o allexport; source .env; set +o allexport

. get_repo.sh

CI_BUILD=no . prepare.sh

SHOULD_BUILD=yes CI_BUILD=no OS_NAME=osx VSCODE_ARCH=x64 . build.sh

cd VSCode-darwin-x64

codesign --deep --force --verbose --sign "$CERTIFICATE_OSX_ID" MrCode.app
