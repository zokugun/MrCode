#!/bin/bash

set -o errexit -o pipefail -o nounset

cd /home/builder

echo "Setting up ssh"
ssh-keyscan -v -t ed25519 aur.archlinux.org >> .ssh/known_hosts

echo -e "${SSH_PRIVATE_KEY//_/\\n}" > .ssh/aur

chmod -vR 600 .ssh/aur*

ssh-keygen -vy -f .ssh/aur > .ssh/aur.pub

sha512sum .ssh/aur .ssh/aur.pub

echo "Setting up git"
git config --global user.name "${GIT_USERNAME}"
git config --global user.email "${GIT_EMAIL}"

echo "Downloading package"
git clone "ssh://aur@aur.archlinux.org/${INPUT_PACKAGE_NAME}.git"
cd "${INPUT_PACKAGE_NAME}"

echo "Setting version: ${INPUT_PACKAGE_VERSION}"
sed -i "s/pkgver=.*$/pkgver=${INPUT_PACKAGE_VERSION}/" PKGBUILD
sed -i "s/pkgrel=.*$/pkgrel=1/" PKGBUILD

echo "Updating checksums"
updpkgsums

echo "Testing package"
makepkg --noconfirm -s -c

echo "Updating SRCINFO"
makepkg --printsrcinfo > .SRCINFO

echo "Tracking files"
git add -fv PKGBUILD .SRCINFO

echo "Detecting changes"
changes=$( git status > /dev/null 2>&1 && git diff-index --quiet HEAD && echo 'no' || echo 'yes' )
if [[ "$changes" == "yes" ]]; then
    echo "Publishing new version"

    version="${INPUT_PACKAGE_VERSION}"
    message=$( echo "${INPUT_COMMIT_MESSAGE}" | envsubst )

    echo "message: $message"

    git commit -m "$message"
    git push
else
    echo "No changes"
fi
