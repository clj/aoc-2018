#!/usr/bin/env sh
set -ex

nim js -d:release -o:day15.js js.nim
nim c -d:release cli.nim

cp day15.js ../www/static/js/
mkdir -p ../www/plaindata/15/
cp ../inputs/15/test_input_* ../www/plaindata/15/
cp ../inputs/15/input ../www/plaindata/15/
