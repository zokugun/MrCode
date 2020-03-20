#!/bin/bash

cd build

exists() { type -t "$1" > /dev/null 2>&1; }

if ! exists gsed; then
	function gsed() {
		sed "$@"
	}
fi

function backup() {
	if [ -f "$1.bak" ]; then
		cp $1.bak $1
	else 
		cp $1 $1.bak
	fi
}

backup 'gulpfile.vscode.js'
gsed -i -E 's/, opts: \{ stats: true \}//g' gulpfile.vscode.js