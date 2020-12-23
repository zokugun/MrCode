#!/bin/bash

set -o allexport; source .env; set +o allexport

. get_repo.sh

. prepare.sh

SHOULD_BUILD=yes CI_BUILD=no VSCODE_ARCH=x64 . build.sh