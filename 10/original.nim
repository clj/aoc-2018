import os
import parseutils
import pegs
import sequtils
import strformat
import terminal


type
  Point = tuple[x, y, vx, vy: int]
  Sky = seq[seq[char]]
  Bounds = tuple[minx, miny, maxx, maxy: int]


var
  points = newSeq[Point]()
  # position=< 9,  1> velocity=< 0,  2>
  pattern = peg"'position=<' \s*{ '-'? \d+ } ',' \s*{ '-'? \d+ } '>' \s* 'velocity=<' \s*{ '-'? \d+ } ',' \s*{ '-'? \d+ } '>'"
  screen_height = terminalHeight()
  screen_width = terminalWidth()


proc parse_integer(s: string): int =
  if s.parse_int(result) == 0:
    echo("Error parsing as int: ", s)
    quit(1)


for line in stdin.lines:
  if line =~ pattern:
    var point: Point = (
      x: parse_integer(matches[0]),
      y: parse_integer(matches[1]),
      vx: parse_integer(matches[2]),
      vy: parse_integer(matches[3]))

    points.add(point)


proc print_sky(sky: Sky) =
  for line in sky:
    for point in line:
      stdout.write(point)
    stdout.write("\n")


proc clear_sky(sky: var Sky) =
  for i in 0..sky.len-1:
    for j in 0..sky[0].len-1:
      sky[i][j] = '.'


proc draw_sky(sky: var Sky, bounds: Bounds) =
  for point in points:
    let x = point.x + -bounds.minx
    let y = point.y + -bounds.miny
    sky[y][x] = '#'


proc move_sky(): Bounds =
  result.minx = high(int)
  result.miny = high(int)
  result.maxx = low(int)
  result.maxy = low(int)
  for i, point in points:
    points[i].x = point.x + point.vx
    points[i].y = point.y + point.vy
    result.minx = min(result.minx, points[i].x)
    result.miny = min(result.miny, points[i].y)
    result.maxx = max(result.maxx, points[i].x)
    result.maxy = max(result.maxy, points[i].y)


proc clear_screen() =
  stdout.write("\E[H\E[2J")
  stdout.flushFile()


clear_screen()
var i: int
while true:
  let bounds = move_sky()
  let width = bounds.maxx - bounds.minx
  let height = bounds.maxy - bounds.miny
  i += 1
  stdout.write(fmt("{i} ({width},{height})\r"))
  if width < screen_width and  height < screen_height:
    var sky = newSeqWith(bounds.maxy - bounds.miny + 1, newSeq[char](bounds.maxx - bounds.minx + 1))
    clear_screen()
    stdout.write(fmt("{i} ({width},{height})\n"))
    clear_sky(sky)
    draw_sky(sky, bounds)
    print_sky(sky)
    sleep(5000)
