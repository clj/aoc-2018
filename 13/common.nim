import algorithm
import sequtils

import ../lib/miniterminal


type
  Tile = object
    track: char
    cart: char
    direction: char
    moved: int
    had_crash: bool
  Map* = seq[seq[ref Tile]]
  Position* = tuple[x, y: int]
  Positions* = seq[Position]
  AnimationState* = tuple
    x, y: int
    colour: ForegroundColor

const
  carts = "<^>v"
  crashed_cart = 'X'
  cart_directions = [(x: -1, y: 0), (x: 0, y: -1), (x: 1, y: 0), (x: 0, y: 1)]
  cart_tracks = "-|-|"
  cart_turn_multiplier = [1, -1, 1, -1]
  track_turn_multiplier = [-1, 1]
  directions = "LSR"
  directions_turn = [-1, 0, 1]
  straight_tracks = "|-"
  intersection_tracks = "+"
  turning_tracks = "/\\"
  empty = char(0)

var
  width = 0
  height = 0
  tick = 1


proc new_map*(input: seq[string]): Map =
  for line in input:
    width = max(width, line.len)
    height += 1

  return newSeqWith(height, newSeq[ref Tile](width))


proc initialise*(map: var Map, input: seq[string]) =
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


proc move*(map: var Map, remove: bool): Positions =
  for y in 0..map.high:
    for x in 0..map[y].high:
      let tile = map[y][x]
      if tile.moved == tick:
        continue
      if tile.cart != empty and tile.cart != crashed_cart:
        let movement = cart_directions[carts.find(tile.cart)]
        let new_tile = map[y + movement.y][x + movement.x]
        if new_tile.cart != empty:
          if remove:
            tile.cart = empty
            new_tile.cart = empty
          else:
            new_tile.cart = crashed_cart
          new_tile.had_crash = true
          result.add((x: x + movement.x, y: y + movement.y))
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


proc find_crash*(map: var Map): (bool, Position) =
  for y in 0..map.high:
    for x in 0..map[y].high:
      let tile = map[y][x]
      if tile.cart == crashed_cart:
        return (true, (x: x, y: y))
  return (false, (x: 0, y: 0))


proc cart_positions*(map: var Map): Positions =
  result = newSeq[Position]()
  for y in 0..map.high:
    for x in 0..map[y].high:
      let tile = map[y][x]
      if tile.cart in carts:
        result.add((x: x, y: y))


proc change_colour[T](output: T, state: var AnimationState, colour: ForegroundColor) =
  if state.colour != colour:
    output.setForegroundColor(colour)
    state.colour = colour


proc print_map*[T](map: var Map, state: var AnimationState, output: T) =
  for row in map:
    for tile in row:
      if tile.cart != empty:
        output.change_colour(state, fgGreen)
        output.write(tile.cart)
      elif tile.had_crash:
        output.change_colour(state, fgRed)
        output.write('X')
      else:
        output.change_colour(state, fgDefault)
        output.write(tile.track)
    output.write("\r\n")


proc animate_map*[T](map: var Map, state: var AnimationState, positions: Positions, output: T) =
  when defined(sorted):
    proc cmp(a, b: Position): int =
      result = cmp(a.x, b.x)
      if result == 0:
        result = cmp(a.y, b.y)

  for position in (when defined(sorted): positions.sorted(cmp) else: positions):
    when defined(not_optimised):
      if position.x != state.x or position.y != state.y:
        output.setCursorPos(position.x + 1, position.y + 1)
    else:
      if position.x == state.x and position.y > state.y:
        output.cursorDown(position.y - state.y)
      elif position.x == state.x and position.y < state.y:
        output.cursorUp(state.y - position.y)
      elif position.y == state.y and position.x > state.x:
        output.cursorForward(position.x - state.x)
      elif position.y == state.y and position.x < state.x:
        output.cursorBackward(state.x - position.x)
      elif position.x != state.x and position.y != state.y:
        output.setCursorPos(position.x + 1, position.y + 1)

    let tile = map[position.y][position.x]
    if tile.cart != empty:
      output.change_colour(state, fgGreen)
      output.write(tile.cart)
    elif tile.had_crash:
      output.change_colour(state, fgRed)
      output.write('X')
    else:
      output.change_colour(state, fgDefault)
      output.write(tile.track)
    state.x = position.x + 1
    state.y = position.y


proc clear_screen*[T](output: T) =
  output.erase_screen()
  output.set_cursor_pos(1, 1)
