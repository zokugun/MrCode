#!/bin/bash

set -o errexit -o pipefail -o nounset

cd stores/aur/mrcode

new_version=$( curl --silent "https://api.github.com/repos/zokugun/MrCode/releases/latest" | jq -r .tag_name )
echo "new_version: $new_version"

old_version=$( cat "PKGBUILD" | sed -n "s/.*pkgver=\([0-9.+]*\).*/\1/p" )
echo "old_version: $old_version"

if [[ "$new_version" != "$old_version" ]]; then
    sed -i "s/pkgver=.*$/pkgver=${new_version}/" PKGBUILD
    sed -i "s/pkgrel=.*$/pkgrel=1/" PKGBUILD

    git add PKGBUILD

    changes=$( git status > /dev/null 2>&1 && git diff-index --quiet HEAD && echo 'no' || echo 'yes' )

    if [[ "$changes" == "yes" ]]; then
        git commit -m "Update mrcode to ${new_version}"
        git push
    else
        echo "No changes"
    fi
else
    echo "Already published"
fi
