#!/usr/bin/env bash

set -e

echo "$#"

cd vscodium || { echo "'vscodium' dir not found"; exit 1; }
cd vscode || { echo "'vscode' dir not found"; exit 1; }

git add .
git reset -q --hard HEAD

while [[ -n "$( git log -1 | grep "VSCODIUM HELPER" )" ]]; do
  git reset -q --hard HEAD~
done

git apply --reject "../patches/helper/settings.patch"

while [ $# -gt 1 ]; do
  echo "Parameter: $1"
  if [[ "${1}" == *patch ]]; then
    FILE="../../patches/${1}"
  else
    FILE="../../patches/${1}.patch"
  fi

  git apply --reject "${FILE}"

  shift
done

git add .
git commit --no-verify -q -m "VSCODIUM HELPER"

if [[ "${1}" == *patch ]]; then
  FILE="../../patches/${1}"
else
  FILE="../../patches/${1}.patch"
fi

if [[ -f "${FILE}" ]]; then
  git apply --reject "${FILE}" || true
fi

read -rp "Press any key when the conflict have been resolved..." -n1 -s

git add .
git diff --staged -U1 > "${FILE}"
git reset -q --hard HEAD~

echo "The patch has been generated."
