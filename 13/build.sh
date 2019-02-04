#!/usr/bin/env sh
set -ex

nim c -d:release -o:day10 cli.nim
nim c -d:release -o:anim anim.nim
./anim < ../inputs/13/test_input_01 > test_input_01.cast
nim c -d:release -d:fps=10 -o:anim anim.nim
./anim < ../inputs/13/input > input.cast
nim c -d:release -d:fps=10 -d:sorted -o:anim.sorted anim.nim
nim c -d:release -d:fps=10 -d:not_optimised -o:anim.not_optimised anim.nim
nim c -d:fps=10 -d:release -d:inefficient -o:anim.inefficient anim.nim
./anim < ../inputs/13/test_input_01 | wc -c
./anim.not_optimised < ../inputs/13/test_input_01 | wc -c
./anim.sorted < ../inputs/13/test_input_01 | wc -c
./anim.inefficient < ../inputs/13/test_input_01 | wc -c
./anim < ../inputs/13/input | wc -c
./anim.not_optimised < ../inputs/13/input | wc -c
./anim.sorted < ../inputs/13/input | wc -c
./anim.inefficient < ../inputs/13/input | wc -c

# Hugo is fairly unhappy about symlinks, so we copy this into the data dir:
mkdir -p ../www/static/casts/13/
cp input.cast ../www/static/casts/13/
cp test_input_01.cast ../www/static/casts/13/
