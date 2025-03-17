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
    VSCODIUM_RELEASE=$( git tag -l --sort=-version:refname | head -1 )

    if [[ "${VSCODIUM_RELEASE}" =~ ^([0-9]+\.[0-9]+\.[0-9]+)\.[0-9]+$ ]];
    then
        MS_TAG="${BASH_REMATCH[1]}"
    else
        echo "Bad VSCODIUM_RELEASE: $VSCODIUM_RELEASE"
        exit 1
    fi

    DATE=$( date +%Y%j )
    export RELEASE_VERSION="$MS_TAG.${DATE: -5}"
else
    if [[ "${RELEASE_VERSION}" =~ ^([0-9]+\.[0-9]+\.[0-9]+)\.[0-9]+$ ]];
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

    VSCODIUM_COMMIT=$( git log --no-show-signature --format="%H" -n 1 )

    # for GH actions
    if [[ $GITHUB_ENV ]]; then
        echo "VSCODIUM_COMMIT=$VSCODIUM_COMMIT" >> $GITHUB_ENV
    fi
fi

if [[ -z "${VSCODIUM_COMMIT}" ]]; then
    echo "Using VSCode tag: ${MS_TAG}"

    VSCODIUM_RELEASE=$( git tag -l --sort=-version:refname | grep "${MS_TAG}" | head -1 )

    echo "Found VSCodium tag: ${VSCODIUM_RELEASE}"

    git checkout $VSCODIUM_RELEASE
else
    echo "Using VSCodium commit: ${VSCODIUM_COMMIT}"

    git checkout $VSCODIUM_COMMIT
fi

cd ..

# for GH actions
if [[ "${GITHUB_ENV}" ]]; then
  echo "MS_TAG=${MS_TAG}" >> "${GITHUB_ENV}"
  echo "VSCODIUM_COMMIT=${VSCODIUM_COMMIT}" >> "${GITHUB_ENV}"
  echo "RELEASE_VERSION=${RELEASE_VERSION}" >> "${GITHUB_ENV}"
fi
