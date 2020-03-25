#!/bin/bash

set -o allexport; source .env; set +o allexport

. get_repo.sh

. prepare.sh

SHOULD_BUILD=yes CI_BUILD=no TRAVIS_OS_NAME=osx . build.sh