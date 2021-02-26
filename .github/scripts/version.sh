#!/bin/bash

set -x

git clone https://github.com/hrydgard/ppsspp.git

LATEST_VERSION="$(cd ppsspp && git describe --tags $(git rev-list --tags --max-count=1) | sed 's/^v//')"
rm -rf ppsspp
snap_name="ppsspp-emu"
# git_repo="hrydgard/ppsspp"
# LATEST_VERSION_TAG="$(curl https://api.github.com/repos/$git_repo/releases/latest -s | jq .tag_name -r)"
# LATEST_VERSION=${LATEST_VERSION_TAG#v}

snap info $snap_name > /dev/null
if [ "$?" -ne 0 ]; then
    echo "Snap not found in store! Building and publishing for first time"
    echo "BUILD=true" >> $GITHUB_ENV
    echo "LATEST_VERSION=$LATEST_VERSION" >> $GITHUB_ENV
else
    CURRENT_VERSION_SNAP="$(snap info $snap_name | grep edge | head -n 2 | tail -n 1 | awk -F ' ' '{print $2}')"

    # compare versions
    if [ $CURRENT_VERSION_SNAP != $LATEST_VERSION ]; then
        echo "versions don't match, github: $LATEST_VERSION snap: $CURRENT_VERSION_SNAP"
        echo "BUILD=true" >> $GITHUB_ENV
        echo "LATEST_VERSION=$LATEST_VERSION" >> $GITHUB_ENV
        echo "CURRENT_VERSION_SNAP=$CURRENT_VERSION_SNAP" >> $GITHUB_ENV
    else
        echo "versions match, github: $LATEST_VERSION snap: $CURRENT_VERSION_SNAP"
        echo "BUILD=false" >> $GITHUB_ENV
    fi
fi


