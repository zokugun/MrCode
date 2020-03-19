#!/bin/bash

if [ -f "update_version.sh.bak" ]; then
    cp update_version.sh.bak update_version.sh
else 
    cp update_version.sh update_version.sh.bak
fi

sed -i '' -E 's|VSCodium/vscodium|zokugun/MrCode|g' update_version.sh
sed -i '' -E 's/vscodium/mrcode/g' update_version.sh
sed -i '' -E 's/VSCodium/MrCode/g' update_version.sh
sed -i '' -E 's|VERSIONS_REPO=.*|VERSIONS_REPO=zokugun/MrCode-versions|' update_version.sh