#!/bin/bash

LATEST_TAG=$(git rev-list --tags --max-count=1)

echo "latest: $( git describe --tags "$LATEST_TAG" | sed 's/\([^-]*-g\)/r\1/;s/-/./g' )"

echo "current: $( git describe --long --tags )"

echo "current: $( git describe --long --tags | sed 's/\([^-]*-g\)/r\1/;s/-/./g' )"
