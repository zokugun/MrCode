#!/bin/bash

### Windows
# to run with Bash: "C:\Program Files\Git\bin\bash.exe" ./build/build.sh
###

export APP_NAME="MrCode"
export BINARY_NAME="mrcode"
export CI_BUILD="no"
export GH_REPO_PATH="zokugun/MrCode"
export ORG_NAME="zokugun"
export SHOULD_BUILD="yes"
export SKIP_ASSETS="yes"
export SKIP_BUILD="no"
export SKIP_SOURCE="no"
export VSCODE_LATEST="no"
export VSCODE_QUALITY="stable"
export VSCODIUM_LATEST="no"

while getopts ":ilmops" opt; do
  case "$opt" in
    i)
      export BINARY_NAME="mrcode-insiders"
      export VSCODE_QUALITY="insider"
      ;;
    l)
      export VSCODE_LATEST="yes"
      ;;
    m)
      export VSCODIUM_LATEST="yes"
      ;;
    o)
      export SKIP_BUILD="yes"
      ;;
    p)
      export SKIP_ASSETS="no"
      ;;
    s)
      export SKIP_SOURCE="yes"
      ;;
    *)
      ;;
  esac
done

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

UNAME_ARCH=$( uname -m )

if [[ "${UNAME_ARCH}" == "arm64" ]]; then
  export VSCODE_ARCH="arm64"
else
  export VSCODE_ARCH="x64"
fi

echo "OS_NAME=\"${OS_NAME}\""
echo "SKIP_SOURCE=\"${SKIP_SOURCE}\""
echo "SKIP_BUILD=\"${SKIP_BUILD}\""
echo "SKIP_ASSETS=\"${SKIP_ASSETS}\""
echo "VSCODE_ARCH=\"${VSCODE_ARCH}\""
echo "VSCODE_LATEST=\"${VSCODE_LATEST}\""
echo "VSCODE_QUALITY=\"${VSCODE_QUALITY}\""

if [[ "${SKIP_SOURCE}" == "no" ]]; then
  rm -rf vscodium*

  . get_repo.sh
  . prepare.sh

  # save variables for later
  echo "MS_TAG=\"${MS_TAG}\"" > build.env
  echo "MS_COMMIT=\"${MS_COMMIT}\"" >> build.env
  echo "RELEASE_VERSION=\"${RELEASE_VERSION}\"" >> build.env
  echo "BUILD_SOURCEVERSION=\"${BUILD_SOURCEVERSION}\"" >> build.env
else
  if [[ "${SKIP_ASSETS}" != "no" ]]; then
    rm -rf vscodium/VSCode*
  fi

  . build.env

  echo "MS_TAG=\"${MS_TAG}\""
  echo "MS_COMMIT=\"${MS_COMMIT}\""
  echo "RELEASE_VERSION=\"${RELEASE_VERSION}\""
  echo "BUILD_SOURCEVERSION=\"${BUILD_SOURCEVERSION}\""
fi

if [[ "${SKIP_BUILD}" == "no" ]]; then
  cd vscodium

  if [[ "${SKIP_SOURCE}" != "no" ]]; then
    git add .
    git reset -q --hard HEAD

    cd ..

    . prepare.sh

    cd vscodium
  fi

  . build.sh

  cd ..

  if [[ "${VSCODE_QUALITY}" == "insider" && "${VSCODE_LATEST}" == "yes" ]]; then
    echo "$( cat "insider.json" | jq --arg 'tag' "${MS_TAG/\-insider/}" --arg 'commit' "${MS_COMMIT}" '. | .tag=$tag | .commit=$commit' )" > "insider.json"
  fi
fi

if [[ "${SKIP_ASSETS}" == "no" ]]; then
  cd vscodium

  if [[ "${OS_NAME}" == "windows" ]]; then
    rm -rf build/windows/msi/releasedir
  fi

  . prepare_assets.sh
fi
