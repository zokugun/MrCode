#!/usr/bin/env bash

# include common functions
. ./vscodium/utils.sh

# include variables
. build.env

case "${OSTYPE}" in
  darwin*)
    export OS_NAME="osx"
    ;;
  msys* | cygwin*)
    export OS_NAME="windows"
    ;;
  *)
    export OS_NAME="linux"
    ;;
esac

export VSCODE_QUALITY="stable"

while getopts ":ilow" opt; do
  case "$opt" in
    i)
      export VSCODE_QUALITY="insider"
      ;;
    l)
      export OS_NAME="linux"
      ;;
    o)
      export OS_NAME="osx"
      ;;
    w)
      export OS_NAME="windows"
      ;;
    *)
      ;;
  esac
done

echo "APP_NAME=\"${APP_NAME}\""
echo "APP_NAME_LC=\"${APP_NAME_LC}\""
echo "BINARY_NAME=\"${BINARY_NAME}\""
echo "GH_REPO_PATH=\"${GH_REPO_PATH}\""
echo "ORG_NAME=\"${ORG_NAME}\""
echo "OS_NAME=\"${OS_NAME}\""
echo "VSCODE_QUALITY=\"${VSCODE_QUALITY}\""

check_file() {
  for file in ../patches/*.patch; do
    if [[ -f "${file}" ]]; then
      apply_patch "${file}" "no"
    fi
  done

  if [[ -d "../patches/${OS_NAME}/" ]]; then
    for file in "../patches/${OS_NAME}/"*.patch; do
      if [[ -f "${file}" ]]; then
        apply_patch "${file}" "no"
      fi
    done
  fi

  while [ $# -gt 1 ]; do
    git apply --reject "${1}"

    shift
  done

  if [[ -f "${1}" ]]; then
    echo applying patch: "${1}"
    if ! git apply --ignore-whitespace "${1}"; then
      echo failed to apply patch "${1}"

      git apply --reject "../patches/helper/settings.patch"

      git add .
      git commit --no-verify -q -m "VSCODIUM HELPER"

      git apply --reject "${1}"

      read -rp "Press any key when the conflict have been resolved..." -n1 -s

      git add .
      git diff --staged -U1 > "${1}"

      git reset -q --hard HEAD~
    fi
  fi

  git add .
  git reset -q --hard HEAD
}

cd vscodium || { echo "'vscodium' dir not found"; exit 1; }
cd vscode || { echo "'vscode' dir not found"; exit 1; }

git add .
git reset -q --hard HEAD

for FILE in ../../patches/*.patch; do
  check_file "${FILE}"
done
