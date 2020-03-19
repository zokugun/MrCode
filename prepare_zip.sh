#!/bin/bash

if [ -f "create_zip.sh.bak" ]; then
    cp create_zip.sh.bak create_zip.sh
else 
    cp create_zip.sh create_zip.sh.bak
fi

sed -i '' -E 's/VSCodium/MrCode/g' create_zip.sh