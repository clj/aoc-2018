#!/usr/bin/env sh
set -ex

DIR=$(dirname "$0")

cd ../10 && ./build.sh && cd $DIR
cd ../13 && ./build.sh && cd $DIR
cd ../17 && ./build.sh && cd $DIR
