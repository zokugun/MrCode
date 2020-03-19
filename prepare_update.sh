#!/bin/bash

if [ -f "patches/update-cache-path.patch.bak" ]; then
    cp patches/update-cache-path.patch.bak patches/update-cache-path.patch
else 
    cp patches/update-cache-path.patch patches/update-cache-path.patch.bak
fi

sed -i '' -E 's/vscodium/mrcode/g' patches/update-cache-path.patch