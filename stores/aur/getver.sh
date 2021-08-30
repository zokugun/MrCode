#!/bin/bash

# Main
package="$1"
variable="$2"
if [[ -z "$package" ]]; then
	echo "$(basename "$0"): package name is required."
	exit 1
fi
if [[ -z "$variable" ]]; then
	echo "$(basename "$0"): variable name is required."
	exit 1
fi

shopt -s nullglob

cd $package

version=$( cat "PKGBUILD" | sed -n "s/.*pkgver=\([0-9.+]*\).*/\1/p" )

echo "$variable: $version"

export $variable="$version"

# for GH actions
if [[ $GITHUB_ENV ]]; then
    echo "$variable=$version" >> $GITHUB_ENV
fi
