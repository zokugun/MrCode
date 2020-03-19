#!/bin/bash

if [ -f "create_dmg.sh.bak" ]; then
    cp create_dmg.sh.bak create_dmg.sh
else 
    cp create_dmg.sh create_dmg.sh.bak
fi

sed -i '' -E 's/VSCodium/MrCode/g' create_dmg.sh