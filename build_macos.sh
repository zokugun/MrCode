#!/bin/bash

./get_repo.sh

# cp -rp src/* vscodium/

cd vscodium || exit

../prepare_build.sh

./get_repo.sh

cd vscode || exit

../../disable_stats.sh

git apply ../../patches/binary-name.patch
git apply ../../patches/disable-stats.patch
git apply ../../patches/editor-open-positioning--sort.patch
git apply ../../patches/editor-folding-strategy--custom.patch

cd ..

SHOULD_BUILD=yes TRAVIS_OS_NAME=osx ./build.sh