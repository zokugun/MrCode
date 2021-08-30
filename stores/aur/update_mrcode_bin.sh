#!/bin/bash

set -o errexit -o pipefail -o nounset

cd stores/aur/mrcode-bin

NEW_RELEASE=$( curl --silent "https://api.github.com/repos/zokugun/MrCode/releases/latest" | jq -r .tag_name )
echo "NEW_RELEASE: $NEW_RELEASE"

OLD_RELEASE=$( cat "PKGBUILD" | sed -n "s/.*pkgver=\([0-9.+]*\).*/\1/p" )
echo "OLD_RELEASE: $OLD_RELEASE"

if [[ "$NEW_RELEASE" != "$OLD_RELEASE" ]]; then
    echo "Setting version: ${NEW_RELEASE}"
    sed -i "s/pkgver=.*$/pkgver=${NEW_RELEASE}/" PKGBUILD
    sed -i "s/pkgrel=.*$/pkgrel=1/" PKGBUILD

    updpkgsums

    echo "Updating SRCINFO"
    makepkg --printsrcinfo > .SRCINFO

    git add -fv PKGBUILD .SRCINFO

    changes=$( git status > /dev/null 2>&1 && git diff-index --quiet HEAD && echo 'no' || echo 'yes' )

    if [[ "$changes" == "yes" ]]; then
        git commit -m "Update mrcode to ${NEW_RELEASE}"
        git push
    else
        echo "No changes"
    fi
else
    echo "Already published"
fi
