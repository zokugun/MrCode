#!/bin/bash

if [ -f "check_tags.sh.bak" ]; then
    cp check_tags.sh.bak check_tags.sh
else 
    cp check_tags.sh check_tags.sh.bak
fi

sed -i '' -E 's|VSCodium/vscodium|zokugun/MrCode|g' check_tags.sh
sed -i '' -E 's/VSCodium/MrCode/g' check_tags.sh