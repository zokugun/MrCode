#!/bin/bash

set -o allexport; source .env; set +o allexport

. get_repo.sh

. prepare.sh

SHOULD_BUILD=yes CI_BUILD=no BUILDARCH=x64 . build.sh