import sequtils
from terminal import terminal_height, terminal_width
import strformat

import common

import ../lib/miniterminal
import ../lib/asciinema

let
  input = map(to_seq(stdin.lines), parse_scan_line)
  height = foldl(map_it(input, max(it.s.y, it.e.y)), max(a, b)) + 1
  min_height = foldl(map_it(input, min(it.s.y, it.e.y)), min(a, b))
  min_width = foldl(map_it(input, min(it.s.x, it.e.x)), min(a, b))
  max_width = foldl(map_it(input, max(it.s.x, it.e.x)), max(a, b))


const
  fps {.intdefine.}: int = 8
  screen_height {.intdefine.}: int = 22
  screen_width {.intdefine.}: int = 30
  delay: float = 1/fps


var
  map = render_scan(input, height, min_width, max_width)
  recording = new_asciinema_recording(stdout, screen_width, screen_height, delay)


recording.hideCursor()
recording.erase_screen()
recording.next_frame()
var changed = true
while changed:
  changed = anim_fill(map)
  let
    lowest = min(height, map.lowest(min_height, height, "|~") + 1)
    top = max(0, lowest - screen_height)
    bottom = min(height, max(lowest, screen_height))
  recording.erase_screen()
  map[top..bottom].output(recording, top)
  recording.next_frame()
recording.showCursor()
recording.next_frame()
