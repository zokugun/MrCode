#!/bin/bash

set -o errexit -o pipefail -o nounset

cd /root

if [[ ! -z "${INPUT_DEPENDS}" ]]; then
    echo "Installing additional dependencies"
    su builder -c "yay -Syu --noconfirm ${INPUT_DEPENDS}"
fi

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

if [[ -z "${INPUT_PACKAGE_VERSION}" ]]; then
    echo "Getting version"

    if [[ "${INPUT_PACKAGE_TYPE}" == "rolling" ]]; then
        cd /tmp

        git clone "https://github.com/${GITHUB_REPOSITORY}.git"

        cd "${GITHUB_REPOSITORY#*/}"

        INPUT_PACKAGE_VERSION=$( git describe --long --tags | sed 's/\([^-]*-g\)/r\1/;s/-/./g' )

        cd "/root/${INPUT_PACKAGE_NAME}"
    else
        INPUT_PACKAGE_VERSION=$( curl --silent "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/latest" | jq -r .tag_name )
    fi
fi

echo "Setting version: ${INPUT_PACKAGE_VERSION}"
sed -i "s/pkgver=.*$/pkgver=${INPUT_PACKAGE_VERSION}/" PKGBUILD
sed -i "s/pkgrel=.*$/pkgrel=1/" PKGBUILD

echo "Updating checksums"
su builder -c "updpkgsums"

echo "Updating SRCINFO"
su builder -c "makepkg --printsrcinfo > .SRCINFO"

echo "Tracking files"
git add -fv PKGBUILD .SRCINFO

echo "Detecting changes"
changes=$( git status > /dev/null 2>&1 && git diff-index --quiet HEAD && echo 'no' || echo 'yes' )
if [[ "$changes" == "yes" ]]; then
    echo "Testing package"
    su builder -c "makepkg --noconfirm -s -c"

    echo "Publishing new version"

    package_name="${INPUT_PACKAGE_NAME}"
    package_version="${INPUT_PACKAGE_VERSION}"

    message=$( echo "${INPUT_COMMIT_MESSAGE}" | envsubst )

    echo "message: $message"

    git commit -m "$message"
    git push
else
    echo "No changes"
fi
