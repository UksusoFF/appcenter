#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$(cd "${SCRIPT_DIR}/../../" && pwd)"

cd "${SOURCE_DIR}"

rm -rf ~/Library/Developer/Xcode/DerivedData/*
rm -rf ~/Library/Caches/org.carthage.CarthageKit/
rm -rf ${SOURCE_DIR}/Carthage/Build/
rm -rf ${SOURCE_DIR}/Carthage/Checkouts/
while read LINE; do
  if [ "$LINE" == "" ]; then
    continue
  fi
  DEP=($(echo "${LINE}" | grep -o '".*"' | tr -d '"'))
  NAME=($(echo "${DEP[0]}" | sed 's/\// /g'))
  carthage checkout "${NAME[1]}"
done <"${SOURCE_DIR}/Cartfile.resolved"

XCODE_XCCONFIG_FILE=${SOURCE_DIR}"/Carthage.xcconfig" carthage build --no-use-binaries --platform macOS
