#!/bin/bash

set -e

if [[ -z "${BUILD_SOURCEVERSION}" ]]; then

    pwd
    ls -la

    npm install -g checksum

    mrcode_hash=$( git rev-parse HEAD )
    echo "mrcode_hash: $mrcode_hash"

    cd vscodium
    vscodium_hash=$( git rev-parse HEAD )
    echo "vscodium_hash: $vscodium_hash"

    cd vscode
    vscode_hash=$( git rev-parse HEAD )
    echo "vscode_hash: $vscode_hash"

    cd ../..

    export BUILD_SOURCEVERSION=$( echo "${mrcode_hash}:${vscodium_hash}:${vscode_hash}" | checksum )

    echo "Build version: ${BUILD_SOURCEVERSION}"

    # for GH actions
    if [[ $GITHUB_ENV ]]; then
        echo "BUILD_SOURCEVERSION=$BUILD_SOURCEVERSION" >> $GITHUB_ENV
    fi
fi

cd vscodium
