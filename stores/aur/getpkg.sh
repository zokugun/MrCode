#!/bin/bash

set -o errexit -o pipefail -o nounset

# Main
package="$1"
if [[ -z "$package" ]]; then
	echo "$(basename "$0"): package name is required."
	exit 1
fi

# Get package
if [[ -d "$package" ]]; then
	echo -e "\033[34mUpdating \033[1m$package\033[0;34m package...\033[0m"
	git -C "$package" pull
else
	echo -e "\033[34mDownloading $package package...\033[0m"
	git clone "ssh://aur@aur.archlinux.org/$package.git"
fi

# Install hooks
echo -e "\033[34mSetting up hooks in \033[1m$package/.git/hooks\033[0;34m directory...\033[0m"
for hook in *.hook.sh
do
    echo "hook: $hook"

	basehook=$( basename "$hook" )
	ln -vsf "$basehook" "$package/.git/hooks/${basehook/.hook.sh}"
done
