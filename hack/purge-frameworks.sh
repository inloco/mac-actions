#!/bin/sh
set -ex

{
    for D in /Library/Frameworks/Mono.* /Library/Frameworks/Xamarin.*
    do
        echo "find '${D}' -type f -delete"
    done
} | parallel --lb

rm -fR /Library/Frameworks/Mono.* /Library/Frameworks/Xamarin.*
