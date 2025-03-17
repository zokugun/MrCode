#!/usr/bin/env bash
# shellcheck disable=SC2129

set -e

if [[ "${SHOULD_BUILD}" != "yes" ]]; then
  echo "Will not update version JSON because we did not build"
  exit 0
fi

jsonTmp=$( cat "./upstream/${VSCODE_QUALITY}.json" | jq --arg 'tag' "${RELEASE_VERSION/\-insider/}" --arg 'commit' "${VSCODIUM_COMMIT}" '. | .tag=$tag | .commit=$commit' )
echo "${jsonTmp}" > "./upstream/${VSCODE_QUALITY}.json" && unset jsonTmp

git add .

CHANGES=$( git status --porcelain )

if [[ -n "${CHANGES}" ]]; then
  git commit -S -m "build(${VSCODE_QUALITY}): update to commit ${MS_COMMIT:0:7}"

  BRANCH_NAME=$( git rev-parse --abbrev-ref HEAD )

  if ! git push origin "${BRANCH_NAME}" --quiet; then
    git pull origin "${BRANCH_NAME}"
    git push origin "${BRANCH_NAME}" --quiet
  fi
fi
