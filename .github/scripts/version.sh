#!/bin/bash

# check latest tagged version
LATEST_VERSION_TAG="$(curl https://api.github.com/repos/Arisotura/melonDS/releases/latest -s | jq .tag_name -r)"
CURRENT_VERSION_SNAP="$(snap info melonds | grep edge | head -n 2 | tail -n 1 | awk -F ' ' '{print $2}')"


# compare versions
if [ $CURRENT_VERSION_SNAP != $LATEST_VERSION_TAG ]; then
    echo "versions don't match, github: $LATEST_VERSION_TAG snap: $CURRENT_VERSION_SNAP"
    echo true >> build
    echo $CURRENT_VERSION_SNAP >> current_version
    echo $LATEST_VERSION_TAG >> latest_version
else
    echo "versions match, github: $LATEST_VERSION_TAG snap: $CURRENT_VERSION_SNAP"
    echo false >> build
fi


