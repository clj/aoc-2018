import sequtils
import strformat

import common
import ../lib/miniterminal


type
  Sky = seq[seq[char]]
  FileLike = concept x
    x.write(string)
    x.write(char)
    x.flush_file()


proc print_sky[T](sky: Sky, output: T) =
  for line in sky:
    for point in line:
      output.write(point)
    output.write("\n")


proc clear_sky(sky: var Sky) =
  for i in 0..sky.len-1:
    for j in 0..sky[0].len-1:
      sky[i][j] = '.'


proc draw_sky[T](sky: var Sky, points: Points[T], bounds: Bounds[T]) =
  for point in points:
    let x = point.x + -bounds.minx
    let y = point.y + -bounds.miny
    sky[y][x] = '#'


proc run[T](points: var Points[T], output: FileLike) =
  output.erase_screen()
  output.set_cursor_pos(0, 0)
  var
    i: int
    last_width, last_height = high(int)
  while true:
    let bounds = points.move_sky()
    let width = bounds.maxx - bounds.minx
    let height = bounds.maxy - bounds.miny
    i += 1
    if last_width < width or last_height < height:
      let bounds = points.move_sky(true)
      var sky = newSeqWith(bounds.maxy - bounds.miny + 1, newSeq[char](bounds.maxx - bounds.minx + 1))
      output.erase_screen()
      output.set_cursor_pos(0, 0)
      output.write(fmt("{i-1} ({last_width},{last_height})\n\n"))
      clear_sky(sky)
      draw_sky(sky, points, bounds)
      print_sky(sky, output)
      quit(0)
    last_width = width
    last_height = height


when isMainModule:
  var points = parse[int](to_seq(stdin.lines))
  points.run(stdout)
