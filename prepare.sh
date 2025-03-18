#!/bin/bash

set -e

DOWNLOAD_VSCODE="yes"

while getopts ":r" opt; do
  case "$opt" in
    r)
      DOWNLOAD_VSCODE="no"
      ;;
    *)
      ;;
  esac
done

function backup() {
	if [ -f "$1.bak" ]; then
		cp $1.bak $1
	else
		cp $1 $1.bak
	fi
}

cp -rp src/* vscodium/

cd vscodium || exit

. ./utils.sh

# prepare_vscode.sh {{{
backup 'prepare_vscode.sh'

gsed -i -E 's|"updateUrl".*|"updateUrl" "https://mrcode.vercel.app"|' prepare_vscode.sh
gsed -i -E 's|"downloadUrl".*|"downloadUrl" "https://github.com/zokugun/MrCode"|' prepare_vscode.sh
gsed -i -E 's|"licenseUrl".*|"licenseUrl" "https://github.com/zokugun/MrCode/blob/master/LICENSE"|' prepare_vscode.sh
gsed -i -E 's|"reportIssueUrl".*|"reportIssueUrl" "https://github.com/zokugun/MrCode/issues/new"|' prepare_vscode.sh

gsed -i -E 's|"nameShort" "VSCodium|"nameShort" "MrCode|' prepare_vscode.sh
gsed -i -E 's|"nameLong" "VSCodium|"nameLong" "MrCode|' prepare_vscode.sh
gsed -i -E 's|"applicationName" "codium|"applicationName" "mrcode|' prepare_vscode.sh
gsed -i -E 's|"dataFolderName" ".vscodium-insiders|"dataFolderName" ".mrcode-insiders|' prepare_vscode.sh
gsed -i -E 's|"linuxIconName" "vscodium|"linuxIconName" "mrcode|' prepare_vscode.sh
gsed -i -E 's|"urlProtocol" "vscodium|"urlProtocol" "mrcode|' prepare_vscode.sh
gsed -i -E 's|"serverApplicationName" "codium-server|"serverApplicationName" "mrcode-server|' prepare_vscode.sh
gsed -i -E 's|"serverDataFolderName" ".vscodium-server|"serverDataFolderName" ".mrcode-server|' prepare_vscode.sh
gsed -i -E 's|"darwinBundleIdentifier" "com.vscodium.VSCodiumInsiders|"darwinBundleIdentifier" "org.zokugun.mrcodeinsiders|' prepare_vscode.sh
gsed -i -E 's|"darwinBundleIdentifier" "com.vscodium|"darwinBundleIdentifier" "org.zokugun.mrcode|' prepare_vscode.sh
gsed -i -E 's|"win32AppUserModelId" "VSCodium.VSCodium|"win32AppUserModelId" "Zokugun.MrCode|' prepare_vscode.sh
gsed -i -E 's|"win32DirName" "VSCodium|"win32DirName" "MrCode|' prepare_vscode.sh
gsed -i -E 's|"win32MutexName" "vscodium|"win32MutexName" "mrcode|' prepare_vscode.sh
gsed -i -E 's|"win32NameVersion" "VSCodium|"win32NameVersion" "MrCode|' prepare_vscode.sh
gsed -i -E 's|"win32RegValueName" "VSCodium|"win32RegValueName" "MrCode|' prepare_vscode.sh
gsed -i -E 's|"win32ShellNameShort" "VSCodium|"win32ShellNameShort" "MrCode|' prepare_vscode.sh


gsed -i -E 's|"win32AppId" "\{\{763CBF88-25C6-4B10-952F-326AE657F16B\}"|"win32AppId" "{{0BD0DE9B-0738-49CE-97C6-75CED083CE4E}"|' prepare_vscode.sh
gsed -i -E 's|"win32x64AppId" "\{\{88DA3577-054F-4CA1-8122-7D820494CFFB\}"|"win32x64AppId" "{{09FF1437-F543-4CF3-9204-C4BB886DF9BE}"|' prepare_vscode.sh
gsed -i -E 's|"win32arm64AppId" "\{\{67DEE444-3D04-4258-B92A-BC1F0FF2CAE4\}"|"win32arm64AppId" "{{035AE7E2-AD42-4139-A9A3-FD9DFC56BDE5}"|' prepare_vscode.sh
gsed -i -E 's|"win32UserAppId" "\{\{0FD05EB4-651E-4E78-A062-515204B47A3A\}"|"win32UserAppId" "{{7D1F645C-DF50-42D7-8054-9BFAF60CEDF3}"|' prepare_vscode.sh
gsed -i -E 's|"win32x64UserAppId" "\{\{2E1F05D1-C245-4562-81EE-28188DB6FD17\}"|"win32x64UserAppId" "{{7678C6A4-C40E-4B93-AA07-D50A6DF862F1}"|' prepare_vscode.sh
gsed -i -E 's|"win32arm64UserAppId" "\{\{57FD70A5-1B8D-4875-9F40-C5553F094828\}"|"win32arm64UserAppId" "{{E25CEB79-4621-482A-ACAE-8FCB57FD29BD}"|' prepare_vscode.sh

gsed -i -E 's=code-oss/codium=code-oss/mrcode=g' prepare_vscode.sh

gsed -i -E 's/Microsoft Corporation\|VSCodium Team/Microsoft Corporation|Zokugun/g' prepare_vscode.sh
gsed -i -E 's/Microsoft Corporation\|VSCodium/Microsoft Corporation|Zokugun/g' prepare_vscode.sh
gsed -i -E 's=\(\[0-9\]\) Microsoft\|\\1 VSCodium=([0-9]) Microsoft|\\1 Zokugun=g' prepare_vscode.sh
gsed -i -E 's/Visual Studio Code\|VSCodium/Visual Studio Code|MrCode/g' prepare_vscode.sh
gsed -i -E 's=https://code\.visualstudio\.com/docs/setup/linux\|https://github\.com/VSCodium/vscodium#download-install=https://code.visualstudio.com/docs/setup/linux|https://github.com/zokugun/MrCode=g' prepare_vscode.sh
gsed -i -E 's=https://code.visualstudio.com\|https://vscodium.com=https://code.visualstudio.com|https://github.com/zokugun/MrCode=g' prepare_vscode.sh
gsed -i -E 's|VSCodium Team https://github.com/VSCodium/vscodium/graphs/contributors|Zokugun https://github.com/zokugun/MrCode/graphs/contributors|g' prepare_vscode.sh

gsed -i -E '/"applicationName" "mrcode".*/a\
  setpath "product" "dataFolderName" ".mrcode"\
' prepare_vscode.sh

# build/linux/appimage/recipe.yml
backup 'build/linux/appimage/recipe.yml'
gsed -i -E 's/VSCodium/MrCode/g' build/linux/appimage/recipe.yml

# build/linux/appimage/build.sh
backup 'build/linux/appimage/build.sh'
gsed -i -E 's/VSCodium\|vscodium/zokugun|MrCode/' build/linux/appimage/build.sh
gsed -i -E 's/VSCodium/MrCode/g' build/linux/appimage/build.sh
gsed -i -E 's/vscodium/mrcode/g' build/linux/appimage/build.sh
gsed -i -E 's/codium/mrcode/g' build/linux/appimage/build.sh

# build/windows/msi/build.sh
backup 'build/windows/msi/build.sh'
gsed -i -E 's/PRODUCT_NAME="VSCodium/PRODUCT_NAME="MrCode/' build/windows/msi/build.sh
gsed -i -E 's/PRODUCT_SKU="vscodium/PRODUCT_SKU="mrcode/' build/windows/msi/build.sh
gsed -i -E 's/PRODUCT_CODE="VSCodium/PRODUCT_CODE="MrCode/' build/windows/msi/build.sh
gsed -i -E 's/PRODUCT_UPGRADE_CODE="965370CD-253C-4720-82FC-2E6B02A53808"/PRODUCT_UPGRADE_CODE="DB7C32FE-9AB3-422E-9A98-47B2361E24A6"/' build/windows/msi/build.sh
gsed -i -E 's/PRODUCT_UPGRADE_CODE="1C9B7195-5A9A-43B3-B4BD-583E20498467"/PRODUCT_UPGRADE_CODE="C3A419D9-B4DF-489A-84CF-4AF763E08965"/' build/windows/msi/build.sh
gsed -i -E 's/OUTPUT_BASE_FILENAME="VSCodium/OUTPUT_BASE_FILENAME="MrCode/' build/windows/msi/build.sh
replace 's|dManufacturerName="VSCodium"|dManufacturerName="zokugun"|s' build/windows/msi/build.sh

# build/windows/msi/vscodium.wxs
# backup 'build/windows/msi/vscodium.wxs'
gsed -i -E 's/VSCodium/MrCode/g' build/windows/msi/vscodium.wxs
gsed -i -E 's/VSCODIUM/MRCODE/g' build/windows/msi/vscodium.wxs

# build/windows/msi/vscodium.xsl
# backup 'build/windows/msi/vscodium.xsl'
gsed -i -E 's/VSCodium/MrCode/g' build/windows/msi/vscodium.xsl
gsed -i -E 's/VSCODIUM/MRCODE/g' build/windows/msi/vscodium.xsl

# LICENSE
backup 'LICENSE'
gsed -i -E 's/.*The VSCodium contributors/Copyright (c) 2020-present Zokugun\
Copyright (c) 2018-present The VSCodium contributors/' LICENSE

for file in build/windows/msi/i18n/*.wxl; do
    if [ -f "$file" ]; then
        # backup "$file"
        gsed -i -E 's|https://github.com/VSCodium/vscodium|https://github.com/zokugun/MrCode|g' "$file"
        gsed -i -E 's/VSCodium/MrCode/g' "$file"
    fi
done

if [[ "${DOWNLOAD_VSCODE}" == "yes" ]]; then
  cp ../patches/*.patch ./patches/user/

  . get_repo.sh

  cd vscode || exit

  # resources/linux/code.appdata.xml
  backup 'resources/linux/code.appdata.xml'
  gsed -i -E 's|<url type="homepage">https://code.visualstudio.com</url>|<url type="homepage">https://github.com/zokugun/MrCode</url>|g' resources/linux/code.appdata.xml
  gsed -i -E 's|<summary>.*</summary>|<summary>MrCode. Code editing.</summary>|g' resources/linux/code.appdata.xml
  gsed -i -E '{N; N; N; N; N; s|<description>.*</description>|<description><p>MrCode is an editor based on Visual Studio Code.</p></description>|g; }' resources/linux/code.appdata.xml

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

  cd ..
fi

cd ..
