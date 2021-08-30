#!/bin/bash

set -o errexit -o pipefail -o nounset

package="$1"
if [[ -z "$package" ]]; then
	echo "$(basename "$0"): package name is required."
	exit 1
fi

if [[ -d "$package" ]]; then
	echo "Updating $package package"
	git -C "$package" pull
else
    echo "Downloading $package package"
	git clone "ssh://aur@aur.archlinux.org/$package.git"
fi
