#!/bin/bash

if [ -d vscodium ];
then
    cd vscodium

    git fetch --all
else
    git clone https://github.com/VSCodium/vscodium.git

    cd vscodium
fi

if [[ -z "${RELEASE_VERSION}" ]]; then
    MS_TAG=$( git tag -l --sort=-version:refname | head -1 )
    date=$( date +%Y%j )
    export RELEASE_VERSION="$MS_TAG+${date: -5}"
else
    if [[ "${RELEASE_VERSION}" =~ ^([0-9]+\.[0-9]+\.[0-9]+)\+[0-9]+$ ]];
    then
        MS_TAG="${BASH_REMATCH[1]}"
    else
        echo "Bad RELEASE_VERSION: $RELEASE_VERSION"
        exit 1
    fi
fi

# for GH actions
if [[ $GITHUB_ENV ]]; then
    echo "MS_TAG=$MS_TAG" >> $GITHUB_ENV
    echo "RELEASE_VERSION=$RELEASE_VERSION" >> $GITHUB_ENV
fi

echo "Release version: ${RELEASE_VERSION}"

if [[ ! -z "${VSCODIUM_LATEST}" ]]; then
    git pull origin master

    VSCODIUM_COMMIT=$( git log --format="%H" -n 1 )

    # for GH actions
    if [[ $GITHUB_ENV ]]; then
        echo "VSCODIUM_COMMIT=$VSCODIUM_COMMIT" >> $GITHUB_ENV
    fi
fi

if [[ -z "${VSCODIUM_COMMIT}" ]]; then
    echo "Using VSCodium tag: ${MS_TAG}"

    git checkout $MS_TAG
else
    echo "Using VSCodium commit: ${VSCODIUM_COMMIT}"

    git checkout $VSCODIUM_COMMIT
fi

cd ..
