#!/bin/bash

if [ -d vscodium ];
then
    cd vscodium

    git fetch --all
else
    git clone https://github.com/VSCodium/vscodium.git

    cd vscodium
fi

if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
  git checkout insider
fi

if [[ -z "${RELEASE_VERSION}" ]]; then
  if [[ "${VSCODIUM_LATEST}" == "yes" ]] || [[ ! -f "../upstream/${VSCODE_QUALITY}.json" ]]; then
    echo "Retrieve lastest version"

    if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
      echo "Not supported"
      exit 1
    else
      git pull origin master

      VSCODIUM_COMMIT=$( git log --no-show-signature --format="%H" -n 1 )
      VSCODIUM_TAG=$( git tag -l --sort=-version:refname | head -1 )
    fi

    if [[ -f "../upstream/${VSCODE_QUALITY}.json" ]]; then
      SAVED_TAG=$( jq -r '.tag' "../upstream/${VSCODE_QUALITY}.json" )

      if [[ "${VSCODIUM_TAG}" != "${SAVED_TAG}" ]]; then
        NEW_RELEASE="true"
      fi
    fi
  else
    echo "Get version from ${VSCODE_QUALITY}.json"
    VSCODIUM_COMMIT=$( jq -r '.commit' "../upstream/${VSCODE_QUALITY}.json" )
    VSCODIUM_TAG=$( jq -r '.tag' "../upstream/${VSCODE_QUALITY}.json" )
  fi

  if [[ "${VSCODIUM_TAG}" =~ ^([0-9]+\.[0-9]+\.[0-5])[0-9]+$ ]];
  then
      MS_TAG="${BASH_REMATCH[1]}"
  else
      echo "Bad VSCodium tag: $VSCODIUM_TAG"
      exit 1
  fi

  TIME_PATCH=$( printf "%04d" $(($(date +%-j) * 24 + $(date +%-H))) )

  if [[ "${VSCODE_QUALITY}" == "insider" ]]; then
    RELEASE_VERSION="${MS_TAG}${TIME_PATCH}-insider"
  else
    RELEASE_VERSION="${MS_TAG}${TIME_PATCH}"
  fi

  git checkout $VSCODIUM_COMMIT
elif [[ "${RELEASE_VERSION}" == "$( jq -r '.release' "../upstream/${VSCODE_QUALITY}.json" )" ]]; then
  echo "Get version from ${VSCODE_QUALITY}.json"
  VSCODIUM_COMMIT=$( jq -r '.commit' "../upstream/${VSCODE_QUALITY}.json" )
  VSCODIUM_TAG=$( jq -r '.tag' "../upstream/${VSCODE_QUALITY}.json" )

  if [[ "${VSCODIUM_TAG}" =~ ^([0-9]+\.[0-9]+\.[0-5])[0-9]+$ ]];
  then
      MS_TAG="${BASH_REMATCH[1]}"
  else
      echo "Bad VSCodium tag: $VSCODIUM_TAG"
      exit 1
  fi
else
    if [[ "${RELEASE_VERSION}" =~ ^([0-9]+\.[0-9]+\.[0-5])[0-9]+$ ]];
    then
        MS_TAG="${BASH_REMATCH[1]}"
    else
        echo "Bad Release version: $RELEASE_VERSION"
        exit 1
    fi

    VSCODIUM_TAG=$( git tag -l --sort=-version:refname | grep "${MS_TAG}" | head -1 )

    echo "Found VSCodium tag: ${VSCODIUM_TAG}"

    git checkout $VSCODIUM_TAG

    VSCODIUM_COMMIT=$( git log --no-show-signature --format="%H" -n 1 )
fi

echo "VSCODIUM_TAG=\"${VSCODIUM_TAG}\""
echo "VSCODIUM_COMMIT=\"${VSCODIUM_COMMIT}\""
echo "NEW_RELEASE=\"${NEW_RELEASE}\""

cd ..

# for GH actions
if [[ "${GITHUB_ENV}" ]]; then
  echo "MS_TAG=${MS_TAG}" >> "${GITHUB_ENV}"
  echo "NEW_RELEASE=${NEW_RELEASE}" >> "${GITHUB_ENV}"
  echo "RELEASE_VERSION=${RELEASE_VERSION}" >> "${GITHUB_ENV}"
  echo "VSCODIUM_TAG=${VSCODIUM_TAG}" >> "${GITHUB_ENV}"
  echo "VSCODIUM_COMMIT=${VSCODIUM_COMMIT}" >> "${GITHUB_ENV}"
fi

export MS_TAG
export NEW_RELEASE
export RELEASE_VERSION
export VSCODIUM_TAG
export VSCODIUM_COMMIT
