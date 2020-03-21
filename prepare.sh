#!/bin/bash

exists() { type -t "$1" > /dev/null 2>&1; }

if ! exists gsed; then
	function gsed() {
		sed "$@"
	}
fi

function backup() {
	if [ -f "$1.bak" ]; then
		cp $1.bak $1
	else
		cp $1 $1.bak
	fi
}

cd vscodium || exit

../prepare.sh

# create_dmg.sh
backup 'create_dmg.sh'
gsed -i -E 's/VSCodium/MrCode/g' create_dmg.sh

# sum.sh
backup 'sum.sh'
gsed -i -E 's/VSCodium/MrCode/g' sum.sh

# create_zip.sh
backup 'create_zip.sh'
gsed -i -E 's/VSCodium/MrCode/g' create_zip.sh

# check_tags.sh
backup 'check_tags.sh'
gsed -i -E 's|VSCodium/vscodium|zokugun/MrCode|g' check_tags.sh
gsed -i -E 's/VSCodium/MrCode/g' check_tags.sh

# update_version.sh
backup 'update_version.sh'
gsed -i -E 's|VSCodium/vscodium|zokugun/MrCode|g' update_version.sh
gsed -i -E 's/vscodium/mrcode/g' update_version.sh
gsed -i -E 's/VSCodium/MrCode/g' update_version.sh
gsed -i -E 's|VERSIONS_REPO=.*|VERSIONS_REPO=zokugun/MrCode-versions|' update_version.sh

./get_repo.sh

cd vscode || exit

# gulpfile.vscode.js
backup 'gulpfile.vscode.js'
gsed -i -E 's/, opts: \{ stats: true \}//g' gulpfile.vscode.js

# build/lib/electron.ts
backup 'build/lib/electron.ts'
gsed -i -E 's|'\''Microsoft Corporation'\''|'\''Zokugun'\''|g' build/lib/electron.ts
gsed -i -E 's|Copyright \(C\) 2019 Microsoft\. All rights reserved|Copyright (C) 2020 Zokugun.|g' build/lib/electron.ts

git apply ../../patches/binary-name.patch
git apply ../../patches/disable-stats.patch
git apply ../../patches/editor-open-positioning--sort.patch
git apply ../../patches/editor-folding-strategy--custom.patch