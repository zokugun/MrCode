#!/bin/bash

set -o errexit -o pipefail -o nounset

NEW_RELEASE=$( git describe --long --tags | sed 's/\([^-]*-g\)/r\1/;s/-/./g' )
echo "NEW_RELEASE: $NEW_RELEASE"

cd stores/aur/mrcode-git

OLD_RELEASE=$( cat "PKGBUILD" | sed -n "s/.*pkgver=\([a-z0-9.+]*\).*/\1/p" )
echo "OLD_RELEASE: $OLD_RELEASE"

if [[ "$NEW_RELEASE" != "$OLD_RELEASE" ]]; then
    echo "Setting version: ${NEW_RELEASE}"
    sed -i "s/pkgver=.*$/pkgver=${NEW_RELEASE}/" PKGBUILD
    sed -i "s/pkgrel=.*$/pkgrel=1/" PKGBUILD

    echo "Updating SRCINFO"
    makepkg --printsrcinfo > .SRCINFO

    git add -fv PKGBUILD .SRCINFO

    changes=$( git status > /dev/null 2>&1 && git diff-index --quiet HEAD && echo 'no' || echo 'yes' )
    echo "changes: $changes"

    if [[ "$changes" == "yes" ]]; then
        git commit -m "Update mrcode to ${NEW_RELEASE}"
        git push
    else
        echo "No changes"
    fi
else
    echo "Already published"
fi
