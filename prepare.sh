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

cp -rp src/* vscodium/

cd vscodium || exit

# build.sh
backup 'build.sh'

if [[ "$CI_BUILD" == "no" ]]; then
	gsed -i -E 's/keep_alive &/date/g' build.sh
	gsed -i -E 's/keep_alive_small &/date/g' build.sh
	gsed -i -E 's/yarn gulp compile-build/yarn gulp compile-build || exit/g' build.sh
fi

gsed -i -z -E 's/\s+yarn gulp vscode-reh-darwin-min-ci\n\s+yarn gulp vscode-reh-web-darwin-min-ci//g' build.sh

# update
backup 'patches/update-cache-path.patch'
gsed -i -E 's/vscodium/mrcode/g' patches/update-cache-path.patch

# prepare_vscode.sh {{{
backup 'prepare_vscode.sh'

gsed -i -E 's/Microsoft\.VSCodium/Zokugun.MrCode/g' prepare_vscode.sh
gsed -i -E 's/VSCodium/MrCode/g' prepare_vscode.sh
gsed -i -E 's/vscodium/mrcode/g' prepare_vscode.sh
gsed -i -E 's/codium/mrcode/g' prepare_vscode.sh
gsed -i -E 's/vscode-server-oss/mrcode-server/g' prepare_vscode.sh

gsed -i -E '/extensionAllowedProposedApi=.*/a\
dataFolderName='\''setpath(["dataFolderName"]; ".mrcode")'\''\
darwinBundleIdentifier='\''setpath(["darwinBundleIdentifier"]; "org.zokugun.mrcode")'\''\
licenseUrl='\''setpath(["licenseUrl"]; "https://github.com/zokugun/MrCode/blob/master/LICENSE")'\''\
reportIssueUrl='\''setpath(["reportIssueUrl"]; "https://github.com/zokugun/MrCode/issues/new")'\''\
enableTelemetry='\''setpath(["enableTelemetry"]; false)'\''
' prepare_vscode.sh
gsed -i -E 's|extensionsGallery=.*|extensionsGallery='\''setpath(["extensionsGallery"]; {"serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery", "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index", "itemUrl": "https://marketplace.visualstudio.com/items"})'\''|g' prepare_vscode.sh
gsed -i -E 's|extensionAllowedProposedApi=.*|extensionAllowedProposedApi='\''setpath(["extensionAllowedProposedApi"]; getpath(["extensionAllowedProposedApi"]) + ["ms-vsliveshare.vsliveshare", "ms-vscode-remote.remote-containers", "ms-vscode-remote.remote-ssh", "ms-vscode-remote.remote-ssh-edit", "ms-vscode-remote.remote-ssh-explorer", "ms-vscode-remote.vscode-remote-extensionpack", "ms-vscode.js-debug", "ms-python.python"])'\''|g' prepare_vscode.sh
gsed -i -z -E 's/linkProtectionTrustedDomains=[^\n]*\n//g' prepare_vscode.sh


gsed -i -E 's/\$\{linkProtectionTrustedDomains\} \| //' prepare_vscode.sh
gsed -i -E 's/\$\{extensionAllowedProposedApi\}/${extensionAllowedProposedApi} | ${dataFolderName} | ${darwinBundleIdentifier} | ${licenseUrl} | ${reportIssueUrl} | ${enableTelemetry}/' prepare_vscode.sh

gsed -i -E $'s/mv product\.json product\.json\.bak/if [ ! -f "product.json.bak" ]; then\\\n  mv product.json product.json.bak\\\nfi/g' prepare_vscode.sh

gsed -i -E 's/patch -u/patch -t -u/g' prepare_vscode.sh
# }}}

# sum.sh
backup 'sum.sh'
gsed -i -E 's/VSCodium/MrCode/g' sum.sh
gsed -i -E 's/checksum -a (sha1|sha256).*/checksum -a \1 "$1" > "$1.\1"/' sum.sh
gsed -i -E '/if \[\[ -f .*/a\
	echo "sum: $1"
' sum.sh
gsed -i -E '/    fi.*/a\
	cat "$1.sha256"
' sum.sh

# check_tags.sh
backup 'check_tags.sh'
gsed -i -E 's|VSCodium/vscodium|zokugun/MrCode|g' check_tags.sh
gsed -i -E 's/VSCodium/MrCode/g' check_tags.sh
gsed -i -E 's/darwin-\$LATEST_MS_TAG/darwin-$VSCODE_ARCH-$LATEST_MS_TAG/g' check_tags.sh

# update_version.sh
backup 'update_version.sh'
gsed -i -E 's|VSCodium/vscodium|zokugun/MrCode|g' update_version.sh
gsed -i -E 's/vscodium/mrcode/g' update_version.sh
gsed -i -E 's/VSCodium/MrCode/g' update_version.sh
gsed -i -E 's|VERSIONS_REPO=.*|VERSIONS_REPO='\''zokugun/MrCode-versions'\''|' update_version.sh
gsed -i -E 's/cd versions/cd MrCode-versions/g' update_version.sh
gsed -i -E 's/ASSET_NAME=MrCode-darwin-\$\{LATEST_MS_TAG\}\.zip/ASSET_NAME=MrCode-darwin-${VSCODE_ARCH}-${LATEST_MS_TAG}.zip/g' update_version.sh
gsed -i -E 's|VERSION_PATH="darwin"|VERSION_PATH="darwin/${VSCODE_ARCH}"|g' update_version.sh

# VSCodium-AppImage-Recipe.yml
backup 'VSCodium-AppImage-Recipe.yml'
gsed -i -E 's/oss\|vscodium/oss|org.zokugun.mrcode/g' VSCodium-AppImage-Recipe.yml
gsed -i -E 's/VSCodium/MrCode/g' VSCodium-AppImage-Recipe.yml
gsed -i -E 's/vscodium/mrcode/g' VSCodium-AppImage-Recipe.yml
gsed -i -E 's/codium/mrcode/g' VSCodium-AppImage-Recipe.yml

# src/resources/linux/appimage/pkg2appimage
backup 'src/resources/linux/appimage/pkg2appimage'
gsed -i -E 's/VSCodium/MrCode/g' src/resources/linux/appimage/pkg2appimage
gsed -i -E 's/vscodium/mrcode/g' src/resources/linux/appimage/pkg2appimage
gsed -i -E 's/CODIUM/MRCODE/g' src/resources/linux/appimage/pkg2appimage
gsed -i -E 's/\$\{!#\}\.yml/${!#}/g' src/resources/linux/appimage/pkg2appimage

. get_repo.sh

cd vscode || exit

# build/gulpfile.vscode.js
backup 'build/gulpfile.vscode.js'
gsed -i -E 's/, opts: \{ stats: true \}//g' build/gulpfile.vscode.js

# build/lib/electron.ts
backup 'build/lib/electron.ts'
gsed -i -E 's|'\''Microsoft Corporation'\''|'\''Zokugun'\''|g' build/lib/electron.ts
gsed -i -E 's|Copyright \(C\) 2019 Microsoft\. All rights reserved|Copyright (C) 2020 Zokugun.|g' build/lib/electron.ts

# LICENSE.txt
backup 'LICENSE.txt'
gsed -i -E '/Corporation.*/a\
Copyright (c) 2020 Zokugun
' LICENSE.txt

# resources/linux/code.appdata.xml
backup 'resources/linux/code.appdata.xml'
gsed -i -E 's|<url type="homepage">https://code.visualstudio.com</url>|<url type="homepage">https://github.com/zokugun/MrCode</url>|g' resources/linux/code.appdata.xml
gsed -i -E 's|<summary>.*</summary>|<summary>MrCode. Code editing.</summary>|g' resources/linux/code.appdata.xml
gsed -i -E '{N; N; N; N; N; s|<description>.*</description>|<description><p>MrCode is an editor based on Visual Studio Code.</p></description>|g; }' resources/linux/code.appdata.xml

# resources/linux/rpm/code.spec.template
backup 'resources/linux/rpm/code.spec.template'
gsed -i -E 's|Summary:  .*|Summary:  Code editing.|g' resources/linux/rpm/code.spec.template
gsed -i -E 's|Vendor:   Microsoft Corporation|Vendor:   Zokugun|g' resources/linux/rpm/code.spec.template
gsed -i -E 's|Packager: Visual Studio Code Team <vscode-linux@microsoft\.com>|Packager: Baptiste Augrain <daiyam@zokugun.org>|g' resources/linux/rpm/code.spec.template
gsed -i -E 's|URL:      https://code\.visualstudio\.com/|URL:      https://github.com/zokugun/MrCode|g' resources/linux/rpm/code.spec.template
gsed -i -E 's|Visual Studio Code is a new choice.*$|MrCode is an editor based on Visual Studio Code.|g' resources/linux/rpm/code.spec.template
gsed -i -E 's|"code"|"mrcode"|g' resources/linux/rpm/code.spec.template
gsed -i -E 's|/code|/mrcode|g' resources/linux/rpm/code.spec.template

# resources/linux/debian/control.template
backup 'resources/linux/debian/control.template'
gsed -i -E 's|Maintainer: Microsoft Corporation <vscode-linux@microsoft\.com>|Maintainer: Baptiste Augrain <daiyam@zokugun.org>|g' resources/linux/debian/control.template
gsed -i -E 's|Homepage: https://code\.visualstudio\.com/|Homepage: https://github.com/zokugun/MrCode|g' resources/linux/debian/control.template
gsed -i -E 's|visual-studio-||g' resources/linux/debian/control.template
gsed -i -E 's|Description: .*|Description: Code editing.|g' resources/linux/debian/control.template
gsed -i -E 's|Visual Studio Code is a new choice.*$|MrCode is an editor based on Visual Studio Code.|g' resources/linux/debian/control.template

# resources/linux/debian/postinst.template
backup 'resources/linux/debian/postinst.template'
gsed -i -E 's|"code"|"mrcode"|g' resources/linux/debian/postinst.template
gsed -i -E 's|/code|/mrcode|g' resources/linux/debian/postinst.template
gsed -i -E 's|vscode|mrcode|g' resources/linux/debian/postinst.template

# resources/linux/snap/snapcraft.yaml
backup 'resources/linux/snap/snapcraft.yaml'
gsed -i -E 's|summary: .*|summary: MrCode. Code editing.|g' resources/linux/snap/snapcraft.yaml
gsed -i -E '{N; N; N; s|Visual Studio Code.*\n.*\n.*|MrCode is an editor based on Visual Studio Code.\n|g;}' resources/linux/snap/snapcraft.yaml

git apply ../../patches/binary-name.patch
git apply ../../patches/editor-open-positioning--sort.patch
git apply ../../patches/editor-folding-strategy--custom.patch

cd ..