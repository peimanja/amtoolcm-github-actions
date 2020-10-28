#!/bin/bash

function parseInputs {
  # Required inputs
  if [ "${INPUT_AMTOOL_ACTIONS_CONFIG}" != "" ]; then
    amConfig=${INPUT_AMTOOL_ACTIONS_CONFIG}
  else
    echo "Input amtool_files cannot be empty"
    exit 1
  fi

  # Optional inputs
  amtoolVersion="latest"
  if [ "${INPUT_AMTOOL_ACTIONS_VERSION}" != "" ] || [ "${INPUT_AMTOOL_ACTIONS_VERSION}" != "latest" ]; then
    amtoolVersion=${INPUT_AMTOOL_ACTIONS_VERSION}
  fi

  amtoolComment=0
  if [ "${INPUT_AMTOOL_ACTIONS_COMMENT}" == "1" ] || [ "${INPUT_AMTOOL_ACTIONS_COMMENT}" == "true" ]; then
    amtoolComment=1
  fi
}


function installAmtool {
  if [[ "${amtoolVersion}" == "latest" ]]; then
    echo "Checking the latest version of Amtool"
    amtoolVersion=$(git ls-remote --tags --refs --sort="v:refname"  git://github.com/prometheus/alertmanager | grep -v '[-].*' | tail -n1 | sed 's/.*\///' | cut -c 2-)
    if [[ -z "${amtoolVersion}" ]]; then
      echo "Failed to fetch the latest version"
      exit 1
    fi
  fi

  
  url="https://github.com/prometheus/alertmanager/releases/download/v${amtoolVersion}/alertmanager-${amtoolVersion}.linux-amd64.tar.gz"

  echo "Downloading Amtool v${amtoolVersion}"
  curl -s -S -L -o /tmp/amtool_${amtoolVersion} ${url}
  if [ "${?}" -ne 0 ]; then
    echo "Failed to download Amtool v${amtoolVersion}"
    exit 1
  fi
  echo "Successfully downloaded Amtool v${amtoolVersion}"

  echo "Unzipping Amtool v${amtoolVersion}"
  tar -zxf /tmp/amtool_${amtoolVersion} --strip-components=1 --directory /usr/local/bin &> /dev/null
  if [ "${?}" -ne 0 ]; then
    echo "Failed to unzip Amtool v${amtoolVersion}"
    exit 1
  fi
  echo "Successfully unzipped Amtool v${amtoolVersion}"
}

function main {
  # Source the other files to gain access to their functions
  scriptDir=$(dirname ${0})
  source ${scriptDir}/amtool_check_config.sh

  parseInputs
  cd ${GITHUB_WORKSPACE}
  installAmtool
  amtoolCheckConfig ${*}

}

main "${*}"
