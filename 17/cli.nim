import sequtils
from terminal import terminal_height, terminal_width
import strformat

import common

import ../lib/miniterminal


let
  input = map(to_seq(stdin.lines), parse_scan_line)
  height = foldl(map_it(input, max(it.s.y, it.e.y)), max(a, b)) + 1
  min_height = foldl(map_it(input, min(it.s.y, it.e.y)), min(a, b))
  min_width = foldl(map_it(input, min(it.s.x, it.e.x)), min(a, b))
  max_width = foldl(map_it(input, max(it.s.x, it.e.x)), max(a, b))
  screen_height = terminal_height() - 3


var
  map = render_scan(input, height, min_width, max_width)


stdout.erase_screen()
var changed = true
while changed:
  changed = fill(map)
  let
    lowest = min(height, map.lowest(min_height, height, "|~") + 1)
    top = max(0, lowest - screen_height)
    bottom = min(height, max(lowest, screen_height))
  stdout.erase_screen()
  map[top..bottom].output(stdout, top)
echo(count(map, min_height, height - 1, "|~"))
echo(count(map, min_height, height - 1, "~"))
