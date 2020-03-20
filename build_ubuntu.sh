#!/bin/bash

./get_repo.sh

cd vscodium || exit

../prepare.sh

./get_repo.sh

cd vscode || exit

git apply ../../patches/binary-name.patch
git apply ../../patches/disable-stats.patch
git apply ../../patches/editor-open-positioning--sort.patch
git apply ../../patches/editor-folding-strategy--custom.patch

cd ..

SHOULD_BUILD=yes BUILDARCH=x64 ./build.sh