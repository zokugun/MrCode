#!/bin/bash

set -o errexit -o pipefail -o nounset

new_version=$( git describe --long --tags | sed 's/\([^-]*-g\)/r\1/;s/-/./g' )
echo "new_version: $new_version"

cd stores/aur/mrcode-git

old_version=$( cat "PKGBUILD" | sed -n "s/.*pkgver=\([a-z0-9.+]*\).*/\1/p" )
echo "old_version: $old_version"

if [[ "$new_version" != "$old_version" ]]; then
    sed -i "s/pkgver=.*$/pkgver=${new_version}/" PKGBUILD
    sed -i "s/pkgrel=.*$/pkgrel=1/" PKGBUILD

    changes=$( git status > /dev/null 2>&1 && git diff-index --quiet HEAD && echo 'no' || echo 'yes' )
    echo "changes: $changes"

    if [[ "$changes" == "yes" ]]; then
        echo "Update mrcode to ${new_version}"

        git commit -m "Update mrcode to ${new_version}"
        git push
    else
        echo "No changes"
    fi
else
    echo "Already published"
fi
