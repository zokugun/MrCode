#!/bin/bash

if [ -f "prepare_vscode.sh.bak" ]; then
    cp prepare_vscode.sh.bak prepare_vscode.sh
else 
    cp prepare_vscode.sh prepare_vscode.sh.bak
fi

sed -i '' -E 's/Microsoft\.VSCodium/Zokugun.MrCode/g' prepare_vscode.sh
sed -i '' -E 's/VSCodium/MrCode/g' prepare_vscode.sh
sed -i '' -E 's/vscodium/mrcode/g' prepare_vscode.sh
sed -i '' -E 's/codium/mrcode/g' prepare_vscode.sh

sed -i '' -E '/extensionAllowedProposedApi=.*/a\
dataFolderName='\''setpath(["dataFolderName"]; ".mrcode")'\''\
darwinBundleIdentifier='\''setpath(["darwinBundleIdentifier"]; "org.zokugun.mrcode")'\''
' prepare_vscode.sh

sed -i '' -E 's/\$\{extensionAllowedProposedApi\}/${extensionAllowedProposedApi} | ${dataFolderName} | ${darwinBundleIdentifier}/' prepare_vscode.sh

sed -i '' -E $'s/mv product\.json product\.json\.bak/if [ ! -f "product.json.bak" ]; then\\\n    mv product.json product.json.bak\\\n  fi/g' prepare_vscode.sh

sed -i '' -E 's/yarn gulp compile-build/yarn gulp compile-build || exit/g' prepare_vscode.sh

sed -i '' -E 's/patch -u/patch -t -u/g' prepare_vscode.sh
