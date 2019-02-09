#!/usr/bin/env sh
set -ex

nim c -d:release -o:day17 cli.nim
nim c -d:release -o:vid vid.nim
nim c -d:release -o:anim anim.nim


./anim < ../inputs/17/test_input_01 > test_input_01.cast
./anim < ../inputs/17/test_input_0A > test_input_0A.cast
./anim < ../inputs/17/test_input_0B > test_input_0B.cast
./anim < ../inputs/17/test_input_0C > test_input_0C.cast
./anim < ../inputs/17/test_input_0D > test_input_0D.cast
./anim < ../inputs/17/test_input_0E > test_input_0E.cast

if ! [ -e ../www/static/videos/17/input.mp4 ]; then
	# Because this takes a while...
	./vid < ../inputs/17/input && ffmpeg -y -f image2  -framerate 60  -pattern_type glob -i 'output/frame_*.png' -pix_fmt yuv420p -profile:v high -level 4  input.mp4
fi

# Hugo is fairly unhappy about symlinks, so we copy this into the data dir:
mkdir -p ../www/static/casts/17/
cp *.cast ../www/static/casts/17/

mkdir -p ../www/static/videos/17/
cp input.mp4 ../www/static/videos/17/
