#!/bin/bash

set -e

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

# update-cache-path.patch
backup 'patches/update-cache-path.patch'
gsed -i -E 's/vscodium/mrcode/g' patches/update-cache-path.patch

# prepare_vscode.sh {{{
backup 'prepare_vscode.sh'

gsed -i -E 's/Microsoft\.VSCodium/Zokugun.MrCode/g' prepare_vscode.sh
gsed -i -E 's/VSCodium/MrCode/g' prepare_vscode.sh
gsed -i -E 's/vscodium/mrcode/g' prepare_vscode.sh
gsed -i -E 's/codium/mrcode/g' prepare_vscode.sh
gsed -i -E 's/vscode-server-oss/mrcode-server/g' prepare_vscode.sh

gsed -i -E 's|updateUrl=.*|updateUrl='\''setpath(["updateUrl"]; "https://mrcode.vercel.app")'\''|' prepare_vscode.sh
gsed -i -E 's|win32x64UserAppId=.*|win32x64UserAppId='\''setpath(["win32x64UserAppId"]; "{{7678C6A4-C40E-4B93-AA07-D50A6DF862F1}}")'\''|' prepare_vscode.sh
gsed -i -E '/extensionAllowedProposedApi=.*/a\
dataFolderName='\''setpath(["dataFolderName"]; ".mrcode")'\''\
darwinBundleIdentifier='\''setpath(["darwinBundleIdentifier"]; "org.zokugun.mrcode")'\''\
licenseUrl='\''setpath(["licenseUrl"]; "https://github.com/zokugun/MrCode/blob/master/LICENSE")'\''\
reportIssueUrl='\''setpath(["reportIssueUrl"]; "https://github.com/zokugun/MrCode/issues/new")'\''\
enableTelemetry='\''setpath(["enableTelemetry"]; false)'\''\
win32AppId='\''setpath(["win32AppId"]; "{{0BD0DE9B-0738-49CE-97C6-75CED083CE4E}}")'\''\
win32x64AppId='\''setpath(["win32x64AppId"]; "{{09FF1437-F543-4CF3-9204-C4BB886DF9BE}}")'\''\
win32arm64AppId='\''setpath(["win32arm64AppId"]; "{{035AE7E2-AD42-4139-A9A3-FD9DFC56BDE5}}")'\''\
win32UserAppId='\''setpath(["win32UserAppId"]; "{{7D1F645C-DF50-42D7-8054-9BFAF60CEDF3}}")'\''\
win32arm64UserAppId='\''setpath(["win32arm64UserAppId"]; "{{E25CEB79-4621-482A-ACAE-8FCB57FD29BD}}")'\''
' prepare_vscode.sh
gsed -i -E 's|extensionsGallery=.*|extensionsGallery='\''setpath(["extensionsGallery"]; {"serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery", "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index", "itemUrl": "https://marketplace.visualstudio.com/items"})'\''|g' prepare_vscode.sh
gsed -i -z -E 's/linkProtectionTrustedDomains=[^\n]*\n//g' prepare_vscode.sh

gsed -i -E 's/\$\{linkProtectionTrustedDomains\} \| //' prepare_vscode.sh
gsed -i -E 's/\$\{extensionAllowedProposedApi\}/${extensionAllowedProposedApi} | ${dataFolderName} | ${darwinBundleIdentifier} | ${licenseUrl} | ${reportIssueUrl} | ${enableTelemetry} | ${win32AppId} | ${win32x64AppId} | ${win32arm64AppId} | ${win32UserAppId} | ${win32arm64UserAppId}/' prepare_vscode.sh

gsed -i -E $'s/mv product\.json product\.json\.bak/if [ ! -f "product.json.bak" ]; then\\\n  mv product.json product.json.bak\\\nfi/g' prepare_vscode.sh

gsed -i -E 's/patch -u/patch -t -u/g' prepare_vscode.sh

gsed -i -E 's/yarn --frozen-lockfile/yarn/g' prepare_vscode.sh
# }}}

# prepare_artifacts.sh
backup 'prepare_artifacts.sh'
gsed -i -E 's/VSCodium/MrCode/g' prepare_artifacts.sh
gsed -i -E 's/MS_TAG/RELEASE_VERSION/g' prepare_artifacts.sh
gsed -i 's|MrCode-${VSCODE_ARCH}-${RELEASE_VERSION}.msi artifacts/|MrCode-${VSCODE_ARCH}-${MS_TAG}.msi artifacts\\\\MrCode-${VSCODE_ARCH}-${RELEASE_VERSION}.msi|' prepare_artifacts.sh
gsed -i 's|MrCode-${VSCODE_ARCH}-updates-disabled-${RELEASE_VERSION}.msi artifacts/|MrCode-${VSCODE_ARCH}-updates-disabled-${MS_TAG}.msi artifacts\\\\MrCode-${VSCODE_ARCH}-updates-disabled-${RELEASE_VERSION}.msi|' prepare_artifacts.sh
gsed -i -E 's|([.-])\$\{RELEASE\_VERSION\}|\1${RELEASE_VERSION/+/.}|g' prepare_artifacts.sh

# check_tags.sh
backup 'check_tags.sh'
gsed -i -E 's|VSCodium/vscodium|zokugun/MrCode|g' check_tags.sh
gsed -i -E 's/VSCodium/MrCode/g' check_tags.sh
gsed -i -E 's/darwin-\$MS_TAG/darwin-$VSCODE_ARCH-$RELEASE_VERSION/g' check_tags.sh
gsed -i -E 's/MS_TAG/RELEASE_VERSION/g' check_tags.sh
gsed -i -E 's|([.-])\$\{RELEASE\_VERSION\}|\1${RELEASE_VERSION/+/.}|g' check_tags.sh

# update_version.sh
backup 'update_version.sh'
gsed -i -E 's|VSCodium/vscodium|zokugun/MrCode|g' update_version.sh
gsed -i -E 's/vscodium/mrcode/g' update_version.sh
gsed -i -E 's/VSCodium/MrCode/g' update_version.sh
gsed -i -E 's|VERSIONS_REPO=.*|VERSIONS_REPO='\''zokugun/MrCode-versions'\''|' update_version.sh
gsed -i -E 's/cd versions/cd MrCode-versions/g' update_version.sh
gsed -i -E 's/ASSET_NAME=MrCode-darwin-\$\{MS_TAG\}\.zip/ASSET_NAME=MrCode-darwin-${VSCODE_ARCH}-${RELEASE_VERSION}.zip/g' update_version.sh
gsed -i -E 's|VERSION_PATH="darwin"|VERSION_PATH="darwin/${VSCODE_ARCH}"|g' update_version.sh
gsed -i -E 's/MS_TAG/RELEASE_VERSION/g' update_version.sh
gsed -i -E 's/MS_COMMIT/BUILD_SOURCEVERSION/g' update_version.sh
gsed -i -E 's|\-\$\{RELEASE\_VERSION\}|-${RELEASE_VERSION/+/.}|g' update_version.sh

# release.sh
backup 'release.sh'
gsed -i -E 's/MS_TAG/RELEASE_VERSION/g' release.sh
gsed -i -E 's|gh release|gh release --repo zokugun/MrCode|g' release.sh
gsed -i -E 's/--owner VSCodium --repo vscodium/--owner zokugun --repo MrCode/g' release.sh

# build/linux/appimage/recipe.yml
backup 'build/linux/appimage/recipe.yml'
gsed -i -E 's/VSCodium/MrCode/g' build/linux/appimage/recipe.yml
gsed -i -E 's/vscodium/mrcode/g' build/linux/appimage/recipe.yml
gsed -i -E 's/codium/mrcode/g' build/linux/appimage/recipe.yml

# build/linux/appimage/build.sh
backup 'build/linux/appimage/build.sh'
gsed -i -E 's/VSCodium\|vscodium/zokugun|MrCode/' build/linux/appimage/build.sh

# build/windows/msi/build.sh
backup 'build/windows/msi/build.sh'
gsed -i -E 's/PRODUCT_NAME="VSCodium"/PRODUCT_NAME="MrCode"/' build/windows/msi/build.sh

# build/windows/msi/vscodium.wxs
backup 'build/windows/msi/vscodium.wxs'
gsed -i -E 's/VSCodium/MrCode/g' build/windows/msi/vscodium.wxs
gsed -i -E 's/VSCODIUM/MRCODE/g' build/windows/msi/vscodium.wxs

# build/windows/msi/vscodium.xsl
backup 'build/windows/msi/vscodium.xsl'
gsed -i -E 's/VSCodium/MrCode/g' build/windows/msi/vscodium.xsl
gsed -i -E 's/VSCODIUM/MRCODE/g' build/windows/msi/vscodium.xsl

# build/windows/msi/includes/vscodium-variables.wxi
backup 'build/windows/msi/includes/vscodium-variables.wxi'
gsed -i -E 's/965370CD-253C-4720-82FC-2E6B02A53808/DB7C32FE-9AB3-422E-9A98-47B2361E24A6/' build/windows/msi/includes/vscodium-variables.wxi

for file in build/windows/msi/i18n/*.wxl; do
    if [ -f "$file" ]; then
        backup "$file"
        gsed -i -E 's|https://github.com/VSCodium/vscodium|https://github.com/zokugun/MrCode|g' "$file"
        gsed -i -E 's/VSCodium/MrCode/g' "$file"
    fi
done

. get_repo.sh

cd vscode || exit

for file in ../../patches/*.patch; do
    if [ -f "$file" ]; then
        echo "applying $(basename -- $file)"

        git apply --ignore-whitespace "$file"

        if [ $? -ne 0 ]; then
            echo "failed to apply $(basename -- $file)" 1>&2
        fi
    fi
done

# package.json
backup 'package.json'
gsed -i -E "s/\"version\": \".*\"/\"version\": \"${RELEASE_VERSION}\"/" package.json

# build/gulpfile.vscode.js
backup 'build/gulpfile.vscode.js'
gsed -i -E 's/, opts: \{ stats: true \}//g' build/gulpfile.vscode.js

# build/lib/electron.ts
backup 'build/lib/electron.ts'
gsed -i -E 's|'\''Microsoft Corporation'\''|'\''Zokugun'\''|g' build/lib/electron.ts
gsed -i -E 's|Copyright \(C\) 2019 Microsoft\. All rights reserved|Copyright (C) 2020-present Zokugun.|g' build/lib/electron.ts

# LICENSE.txt
backup 'LICENSE.txt'
gsed -i -E '/Corporation.*/a\
Copyright (c) 2020-present Zokugun
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

cd ../..
