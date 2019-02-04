import os
import sequtils
import strformat
from terminal import terminal_height, terminal_width

import common

import ../lib/miniterminal


const
  delay = 500

let
  input = to_seq(stdin.lines)
  screen_height = terminal_height()
  screen_width = terminal_width()

var
  output: bool
  map = new_map(input)
  animation_state: AnimationState = (x: -1, y: -1, colour: fgDefault)


if screen_width > len(map) and screen_height > len(map):
  output = true
else:
  output = false

###
# Part I
###

map.initialise(input)

if output:
  clear_screen(stdout)

var first_crash: Position

while true:
  if output:
    map.print_map(animation_state, stdout)
  var crashed: bool
  (crashed, first_crash) = map.find_crash()
  if crashed:
    break
  if output:
    sleep(delay)
  discard map.move(false)
  if output:
    clear_screen(stdout)

###
# Part II
###

if output:
  clear_screen(stdout)
map.initialise(input)

var remaining_carts: seq[Position]

animation_state = (x: -1, y: -1, colour: fgDefault)
while true:
  if output:
    map.print_map(animation_state, stdout)
  remaining_carts = map.cart_positions()
  if remaining_carts.len == 1:
    break
  if output:
    sleep(delay)
  discard map.move(true)
  if output:
    clear_screen(stdout)

echo(fmt"{first_crash.x},{first_crash.y}")
echo(fmt"{remaining_carts[0].x},{remaining_carts[0].y}")
