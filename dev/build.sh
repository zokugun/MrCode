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

if [[ "${UNAME_ARCH}" == "aarch64" || "${UNAME_ARCH}" == "arm64" ]]; then
  export VSCODE_ARCH="arm64"
elif [[ "${UNAME_ARCH}" == "ppc64le" ]]; then
  export VSCODE_ARCH="ppc64le"
elif [[ "${UNAME_ARCH}" == "riscv64" ]]; then
  export VSCODE_ARCH="riscv64"
elif [[ "${UNAME_ARCH}" == "loongarch64" ]]; then
  export VSCODE_ARCH="loong64"
elif [[ "${UNAME_ARCH}" == "s390x" ]]; then
  export VSCODE_ARCH="s390x"
else
  export VSCODE_ARCH="x64"
fi

export NODE_OPTIONS="--max-old-space-size=8192"

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

  if [[ -f "./include_${OS_NAME}.gypi" ]]; then
    echo "Installing custom ~/.gyp/include.gypi"

    mkdir -p ~/.gyp

    if [[ -f "${HOME}/.gyp/include.gypi" ]]; then
      mv ~/.gyp/include.gypi ~/.gyp/include.gypi.pre-vscodium
    else
      echo "{}" > ~/.gyp/include.gypi.pre-vscodium
    fi

    cp ./build/osx/include.gypi ~/.gyp/include.gypi
  fi

  . build.sh

  cd ..

  if [[ "${VSCODIUM_LATEST}" == "yes" ]]; then
    jsonTmp=$( cat "./upstream/${VSCODE_QUALITY}.json" | jq --arg 'tag' "${VSCODIUM_RELEASE/\-insider/}" --arg 'commit' "${VSCODIUM_COMMIT}" '. | .tag=$tag | .commit=$commit' )
    echo "${jsonTmp}" > "./upstream/${VSCODE_QUALITY}.json" && unset jsonTmp
  fi
fi

if [[ "${SKIP_ASSETS}" == "no" ]]; then
  cd vscodium

  if [[ "${OS_NAME}" == "windows" ]]; then
    rm -rf build/windows/msi/releasedir
  fi

  . prepare_assets.sh
fi
