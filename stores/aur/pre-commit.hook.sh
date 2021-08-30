#!/bin/bash

# Constants
GIT_ROOT="$(git rev-parse --show-toplevel)"
TMP_FILE="/tmp/fileslist"

# Main
cd "$GIT_ROOT" || exit 255
if [[ ! -f PKGBUILD ]]; then
	echo -e "\033[1;31mNo PKGBUILD found in $GIT_ROOT\033[0m"
	exit 1
fi

analysis="$(namcap PKGBUILD)"
if [[ -n "$analysis" ]]; then
	echo -e "\033[1;33mPKGBUILD analysis shows problems:\033[0m\n$analysis"
	exit -1
fi

if [[ -z "$SKIPSUMS" ]]; then
	ls -1 > "$TMP_FILE"

	if ! updpkgsums; then
		echo -e "\033[1;31mFailed to update checksums\033[0m"
		exit 2
	fi

	if ! makepkg --printsrcinfo > .SRCINFO; then
		echo -e "\033[1;31mFailed to generate .SCRINFO\033[0m"
		exit 3
	fi

	# Remove downloaded files
	ls -1 >> "$TMP_FILE"
	todelete=$(sort "$TMP_FILE" | uniq -u)
	if [[ -n "$todelete" ]]; then
		rm -v "$todelete"
	fi
	rm "$TMP_FILE"
fi

git add PKGBUILD .SRCINFO
