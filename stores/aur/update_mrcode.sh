#!/bin/bash

cd mrcode

git_version=$( curl --silent "https://api.github.com/repos/zokugun/MrCode/releases/latest" | jq -r .tag_name )
echo "git_version: $git_version"

aur_version=$( cat "PKGBUILD" | sed -n "s/.*pkgver=\([0-9.+]*\).*/\1/p" )
echo "aur_version: $aur_version"

if [[ "$git_version" == "$aur_version" ]]; then
    sed -i "s/pkgver=.*$/pkgver=${git_version}/" PKGBUILD
    sed -i "s/pkgrel=.*$/pkgrel=1/" PKGBUILD

    changes=$( git diff-index --quiet HEAD && echo 'no' || echo 'yes' )

    if (( "$changes" == "yes" )); then
        git commit -m "Update mrcode to ${RELEASE_VERSION}"
        git push
    else
        echo "No changes"
    fi
else
    echo "Already published"
fi
