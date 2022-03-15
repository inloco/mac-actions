#!/bin/sh
set -ex

XCODE_LINK=/Applications/Xcode.app
XCODE_REAL=$(readlink "${XCODE_LINK}")

unlink "${XCODE_LINK}"
mv "${XCODE_REAL}" "${XCODE_LINK}"

{
    for D in /Applications/Xcode_*
    do
        echo rsync -aP --del /var/empty/ "${D}"
    done
} | parallel --lb ::::

rm -fR /Applications/Xcode_*
