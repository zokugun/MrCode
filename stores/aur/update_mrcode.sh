#!/bin/bash

if [[ -z "$RELEASE_VERSION" ]]; then
	echo "RELEASE_VERSION is required."
	exit 1
fi

cd mrcode

sed -i "s/pkgver=.*$/pkgver=${RELEASE_VERSION}/" PKGBUILD
sed -i "s/pkgrel=.*$/pkgrel=1/" PKGBUILD

changes=$( git diff-index --quiet HEAD && echo 'no' || echo 'yes' )

if (( "$changes" === "yes" )); then
    git commit -m "Update mrcode to ${RELEASE_VERSION}"
    git push
else
    echo "No changes"
fi
