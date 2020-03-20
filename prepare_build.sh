#!/bin/bash

if [ -f "build.sh.bak" ]; then
    cp build.sh.bak build.sh
else 
    cp build.sh build.sh.bak
fi

sed -i '' -E 's/keep_alive &/# keep_alive &/g' build.sh
sed -i '' -E 's/keep_alive_small &/# keep_alive_small &/g' build.sh