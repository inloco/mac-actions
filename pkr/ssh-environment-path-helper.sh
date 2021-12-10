#!/bin/sh
set -ex

while true
do
	{
		echo 'ANDROID_SDK_ROOT=/usr/local/share/android-commandlinetools'
		/usr/libexec/path_helper -s | sed -e 's/"//g' -e 's/;.*//g'
	} > /private/etc/ssh/ssh_environment
done
