#!/usr/bin/env sh
set -ex

nim c -d:release -o:day10 cli.nim
nim js -d:release -o:day10.js js.nim
nim c -d:release to_json.nim
./to_json < ../inputs/10/input > input.json
./to_json < ../inputs/10/test_input_01 > test_input_01.json
# Hugo is fairly unhappy about symlinks, so we copy this into the data dir:
cp input.json ../www/data/10/
cp test_input_01.json ../www/data/10/
cp day10.js ../www/static/js/