#!/bin/bash

./reset.sh

set -o allexport; source .env; set +o allexport

. get_repo.sh

CI_BUILD=no . prepare.sh

SHOULD_BUILD=yes CI_BUILD=no TRAVIS_OS_NAME=osx . build.sh

cd VSCode-darwin

codesign --deep --force --verbose --sign "$CERTIFICATE_OSX_ID" MrCode.app
