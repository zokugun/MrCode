#!/bin/bash

if [ -f "sum.sh.bak" ]; then
    cp sum.sh.bak sum.sh
else 
    cp sum.sh sum.sh.bak
fi

sed -i '' -E 's/VSCodium/MrCode/g' sum.sh