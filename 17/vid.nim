import os
import sequtils
import strformat

import common

import ../lib/stb_image_write


const
  aspect_ratio = 9/16


type
  Pixel = tuple[r, g, b: uint8]
  PixelData = seq[Pixel]


let
  input = map(to_seq(stdin.lines), parse_scan_line)
  height = foldl(map_it(input, max(it.s.y, it.e.y)), max(a, b)) + 1
  min_height = foldl(map_it(input, min(it.s.y, it.e.y)), min(a, b))
  min_width = foldl(map_it(input, min(it.s.x, it.e.x)), min(a, b))
  max_width = foldl(map_it(input, max(it.s.x, it.e.x)), max(a, b))

var
  map = render_scan(input, height, min_width, max_width)


proc frame(map: var Map, image: var PixelData, pixel_size, img_width, top, bottom: int) =
  for y in top..bottom:
    for x, pixel in map[y]:
      let
        sx = x * pixel_size
        sy = (y - top) * pixel_size
        idx = sy * img_width + sx
      for yi in 0..pixel_size:
        let idx = idx + yi * img_width
        for xi in 0..pixel_size:
          let idx = idx + xi
          if idx > image.high:
            break
          if pixel == '~':
            image[idx] = (r: 30'u8, g: 60'u8, b: 120'u8)
          elif pixel == '|':
            image[idx] = (r: 20'u8, g: 40'u8, b: 180'u8)
          elif pixel == '#':
            image[idx] = (r: 88'u8, g: 62'u8, b: 36'u8)
          elif pixel == '.':
            image[idx] = (r: 0'u8, g: 0'u8, b: 0'u8)


const
  pixel_size {.intdefine.}: int = 4
  extra_frames {.intdefine.}: int = 60*10


let
  img_width = cint((max_width - min_width + 3) * pixel_size)
  img_height_unadj = cint(float(img_width) * aspect_ratio)
  img_height = cint(img_height_unadj + (pixel_size - img_height_unadj %% pixel_size))
  img_cells = img_height div pixel_size


var
  changed = true
  image = newSeq[Pixel](img_width * img_height)
  lowest = min_height
  i = 0


template write_frame() =
  discard stbi_write_png(fmt"output/frame_{i:010d}.png", img_width, img_height, 3, addr image[0], img_width * 3)


create_dir("output")
map.frame(image, pixel_size, img_width, 0, lowest)
write_frame()
while changed:
  changed = anim_fill(map)
  lowest = min(height, map.lowest(min_height, min(height, lowest + 1), "|~") + 5)
  let
    top = max(0, lowest - img_cells)
    bottom = min(height, max(lowest, img_cells))
  map.frame(image, pixel_size, img_width, top, bottom)
  write_frame()
  i += 1
for i in i..i+extra_frames:
  write_frame()