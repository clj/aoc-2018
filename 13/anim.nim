import sequtils

import ../lib/asciinema
import ../lib/miniterminal

import common

const
  fps {.intdefine.}: int = 4
  delay: float = 1/fps

let
  input = to_seq(stdin.lines)

var
  map = new_map(input)
  recording = new_asciinema_recording(stdout, map[0].len + 1, map.len + 1, delay)

map.initialise(input)

var
  previous_carts = map.cart_positions()
  remaining_carts: Positions
  crashed_carts: Positions
  animation_state: AnimationState = (x: -1, y: -1, colour: fgDefault)

recording.hideCursor()
recording.clear_screen()

when defined(inefficient):
  while true:
    map.print_map(animation_state, recording)
    recording.next_frame()
    remaining_carts = map.cart_positions()
    if remaining_carts.len == 1:
      break
    discard map.move(true)
    recording.clear_screen()
else:
  map.print_map(animation_state, recording)
  while true:
    recording.next_frame()
    crashed_carts = map.move(true)
    remaining_carts = map.cart_positions()
    map.animate_map(animation_state, previous_carts & remaining_carts & crashed_carts, recording)
    if remaining_carts.len == 1:
      recording.next_frame()
      break
    previous_carts = remaining_carts

recording.showCursor()
