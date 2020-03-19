#!/bin/bash

cd build

if [ -f "gulpfile.vscode.js.bak" ]; then
    cp gulpfile.vscode.js.bak gulpfile.vscode.js
else 
    cp gulpfile.vscode.js gulpfile.vscode.js.bak
fi

sed -i '' -E 's/, opts: \{ stats: true \}//g' gulpfile.vscode.js