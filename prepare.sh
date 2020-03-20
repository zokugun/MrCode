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

# build.sh
backup 'build.sh'
gsed -i -E 's/keep_alive &/date/g' build.sh
gsed -i -E 's/keep_alive_small &/date/g' build.sh

# update
backup 'patches/update-cache-path.patch'
gsed -i -E 's/vscodium/mrcode/g' patches/update-cache-path.patch

# prepare_vscode.sh {{{
backup 'prepare_vscode.sh'

gsed -i -E 's/Microsoft\.VSCodium/Zokugun.MrCode/g' prepare_vscode.sh
gsed -i -E 's/VSCodium/MrCode/g' prepare_vscode.sh
gsed -i -E 's/vscodium/mrcode/g' prepare_vscode.sh
gsed -i -E 's/codium/mrcode/g' prepare_vscode.sh

gsed -i -E '/extensionAllowedProposedApi=.*/a\
dataFolderName='\''setpath(["dataFolderName"]; ".mrcode")'\''\
darwinBundleIdentifier='\''setpath(["darwinBundleIdentifier"]; "org.zokugun.mrcode")'\''
' prepare_vscode.sh

gsed -i -E 's/\$\{extensionAllowedProposedApi\}/${extensionAllowedProposedApi} | ${dataFolderName} | ${darwinBundleIdentifier}/' prepare_vscode.sh

gsed -i -E $'s/mv product\.json product\.json\.bak/if [ ! -f "product.json.bak" ]; then\\\n    mv product.json product.json.bak\\\n  fi/g' prepare_vscode.sh

gsed -i -E 's/yarn gulp compile-build/yarn gulp compile-build || exit/g' prepare_vscode.sh

gsed -i -E 's/patch -u/patch -t -u/g' prepare_vscode.sh
# }}}