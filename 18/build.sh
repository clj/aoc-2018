#!/usr/bin/env sh
set -ex

nim js -d:release -o:day18.js js.nim
nim c -d:release cli.nim

cp day18.js ../www/static/js/
mkdir -p ../www/plaindata/18/
cp ../inputs/18/test_input_* ../www/plaindata/18/
cp ../inputs/18/input ../www/plaindata/18/
