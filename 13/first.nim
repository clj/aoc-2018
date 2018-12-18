import sequtils
import strformat
import os


type
  Tile = object
    track: char
    cart: char
    direction: char
    moved: int
  Map = seq[seq[Tile]]

const
  carts = "<^>v"
  crashed_cart = 'X'
  cart_directions = [(x: -1, y: 0), (x: 0, y: -1), (x: 1, y: 0), (x: 0, y: 1)]
  cart_tracks = "-|-|"
  directions = "LSR"
  directions_turn = [-1, 0, 1]
  cart_turn_multiplier = [1, -1, 1, -1]
  track_turn_multiplier = [-1, 1]
  straight_tracks = "|-"
  intersection_tracks = "+"
  turning_tracks = "/\\"
  empty = char(0)
  delay = 500

let input = to_seq(stdin.lines)

var
  width = 0
  height = 0
  tick = 1

for line in input:
  width = max(width, line.len)
  height += 1

var map = newSeqWith(height, newSeq[ref Tile](width))

for y, line in input:
  for x, ch in line:
    map[y][x] = new Tile
    map[y][x].track = ch
    let cart_loc = carts.find(ch)
    if cart_loc != -1:
      map[y][x].track = cart_tracks[cart_loc]
      map[y][x].cart = ch
      map[y][x].direction = directions[0]
      map[y][x].moved = -1


proc move() =
  for y in 0..map.high:
    for x in 0..map[y].high:
      let tile = map[y][x]
      if tile.moved == tick:
        continue
      if tile.cart != empty and tile.cart != crashed_cart:
        let movement = cart_directions[carts.find(tile.cart)]
        let new_tile = map[y + movement.y][x + movement.x]
        if new_tile.cart != empty:
          new_tile.cart = crashed_cart
          continue
        new_tile.cart = tile.cart
        new_tile.direction = tile.direction
        new_tile.moved = tick
        tile.cart = empty
        if new_tile.track in intersection_tracks & turning_tracks:
          var turn: int
          let current_direction_idx = carts.find(new_tile.cart)
          if new_tile.track in intersection_tracks:
            let turn_idx = directions.find(new_tile.direction)
            turn = directions_turn[turn_idx]
            let new_direction_idx = (turn_idx + 1) %% directions.len
            new_tile.direction = directions[new_direction_idx]
          else:
            let cart_idx = carts.find(new_tile.cart)
            let track_idx = turning_tracks.find(new_tile.track)
            turn = cart_turn_multiplier[cart_idx] * track_turn_multiplier[track_idx]
          let new_cart_direction_idx = (current_direction_idx + turn) %% carts.len
          new_tile.cart = carts[new_cart_direction_idx]

  tick += 1


proc has_crashed() =
  for y in 0..map.high:
    for x in 0..map[y].high:
      let tile = map[y][x]
      if tile.cart == crashed_cart:
        echo(fmt"{x},{y}")
        quit(0)


proc clear_screen() =
  stdout.write("\E[H\E[2J")
  stdout.flushFile()


proc print_map() =
  for row in map:
    for tile in row:
      if tile.cart != empty:
        stdout.write(tile.cart)
      else:
        stdout.write(tile.track)
    stdout.write("\n")


const output = true

if output:
  clear_screen()

while true:
  if output:
    print_map()
  has_crashed()
  if output:
    sleep(delay)
  move()
  if output:
    clear_screen()
