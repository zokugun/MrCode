#!/bin/bash

cd vscodium || exit

../prepare_build.sh
../prepare_update.sh

../prepare_dmg.sh
../prepare_sum.sh
../prepare_zip.sh

../prepare_tags.sh
../prepare_version.sh

./get_repo.sh

cd vscode || exit

../../disable_stats.sh

git apply ../../patches/binary-name.patch
git apply ../../patches/disable-stats.patch
git apply ../../patches/editor-open-positioning--sort.patch
git apply ../../patches/editor-folding-strategy--custom.patch