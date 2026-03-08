#!/usr/bin/env bash

set -e

normalize_file() {
  if [[ "${1}" == *patch ]]; then
    FILE="${1}"
  else
    FILE="${1}.patch"
  fi

  if [[ "${FILE}" == patches/* ]]; then
    FILE="../../${FILE}"
  else
    FILE="../../patches/${FILE}"
  fi
}

cd vscodium || { echo "'vscodium' dir not found"; exit 1; }
cd vscode || { echo "'vscode' dir not found"; exit 1; }

git add .
git reset -q --hard HEAD

while [[ -n "$( git log -1 | grep "VSCODIUM HELPER" )" ]]; do
  git reset -q --hard HEAD~
done

git apply --reject "../patches/helper/settings.patch"

for FILE in ../patches/*.patch; do
  if [[ -f "${FILE}" ]]; then
    git apply --reject "${FILE}" || true
  fi
done

while [ $# -gt 1 ]; do
  echo "Parameter: $1"
  normalize_file "${1}"

  git apply --reject "${FILE}" || true

  shift
done

git add .
git commit --no-verify -q -m "VSCODIUM HELPER"

normalize_file "${1}"

echo "${FILE}"

if [[ -f "${FILE}" ]]; then
  git apply --reject "${FILE}" || true
fi

read -rp "Press any key when the conflict have been resolved..." -n1 -s

# while [[ -n "$( find . -name '*.rej' -print )" ]]; do
#   echo
#   read -rp "Press any key when the conflict have been resolved..." -n1 -s
# done

git add .
git diff --staged -U1 > "${FILE}"
git reset -q --hard HEAD~

echo "The patch has been generated."
