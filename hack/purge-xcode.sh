#!/bin/sh
set -ex

XCODE_LINK=/Applications/Xcode.app
XCODE_REAL=$(readlink "${XCODE_LINK}")

unlink "${XCODE_LINK}"
mv "${XCODE_REAL}" "${XCODE_LINK}"

sudo xcode-select -s "${XCODE_LINK}"

find /Applications -type l -maxdepth 1 -delete

{
    for D in /Applications/Xcode_*.app/Contents/Developer/Platforms/*.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/*.simruntime/Contents/Resources/RuntimeRoot
    do
        echo "find '${D}' -type f -delete"
    done
} | parallel --lb

{
    for D in /Applications/Xcode_*.app/Contents/Developer/Platforms/*.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/*.simruntime
    do
        echo "find '${D}' -type f -delete"
    done
} | parallel --lb

{
    for D in /Applications/Xcode_*.app/Contents/Developer/Platforms/*.platform
    do
        echo "find '${D}' -type f -delete"
    done
} | parallel --lb

{
    for D in /Applications/Xcode_*.app/Contents/Developer
    do
        echo "find '${D}' -type f -delete"
    done
} | parallel --lb

{
    for D in /Applications/Xcode_*.app/Contents
    do
        echo "find '${D}' -type f -delete"
    done
} | parallel --lb

{
    for D in /Applications/Xcode_*.app
    do
        echo "find '${D}' -type f -delete"
    done
} | parallel --lb

rm -fR /Applications/Xcode_*.app
