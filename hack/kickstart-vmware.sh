#!/bin/sh
set -ex

until vctl system start
do
    :
done

vctl system stop --force
