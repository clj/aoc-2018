import strutils
import strformat
import sequtils

const
  open* = '.'
  tree* = '|'
  lumber* = '#'


type
  Map* = seq[seq[char]]
  Point = tuple[x, y: int]
  Points = seq[Point]


proc `$`*(map: Map): string =
  var
    colour: string

  proc change_colour(new_colour: string): string =
    if colour != new_colour:
      result = "\e[" & new_colour & "m"
      colour = new_colour
    else:
      result = ""

  result &= change_colour("37")
  if map.len >= 10:
    result &= "    "
    for i in 0..map.high:
      if i != 0 and i %% 10 == 0:
        result &= fmt"{i/10}"
      else:
        result &= " "
    result &= "\r\n"
  result &= "    "
  for i in 0..map.high:
    result &= fmt"{i%%10}"
  result &= "\r\n"
  for i, line in map:
    result &= change_colour("37")
    if i != 0 and i %% 10 == 0:
      result &= fmt"{i:3} "
    else:
      result &= fmt"{i%%10:3} "
    for square in line:
      case square:
        of '.': result &= change_colour("38;2;0;80;0")
        of '|': result &= change_colour("38;2;124;252;0")
        of '#': result &= change_colour("38;2;139;69;19")
        else: assert false
      result &= square
    result &= "\r\n"


proc input_to_map*(input: openarray[string]): Map =
  let width = input.len
  let height = input[0].len
  result = newSeqWith(height, newSeq[char](width))
  for y in 0..result.high:
    for x in 0..result[0].high:
      result[y][x] = input[y][x]


proc adjecent_points(p: Point): Points =
  for i in -1..1:
    for j in -1..1:
      if i == 0 and j == 0:
        continue
      result.add((p.x + i, p.y + j))


proc bounded_adjacent_points(map: Map, p: Point): Points =
  return filter_it(adjecent_points(p), it.x >= 0 and it.y >= 0 and it.x < map.len and it.y < map[0].len)


proc count_adjecent(m: Map, p: Point, typ: char): int =
  for p in bounded_adjacent_points(m, p):
    if m[p.y][p.x] == typ:
      result += 1


proc iterate*(src_map: Map, dst_map: var Map): bool =
  for y in 0..src_map.high:
    for x in 0..src_map[0].high:
      let current_acre = src_map[y][x]
      dst_map[y][x] = src_map[y][x]
      if current_acre == open and count_adjecent(src_map, (x, y), tree) >= 3:
        dst_map[y][x] = tree
        result = result or true
      elif current_acre == tree and count_adjecent(src_map, (x, y), lumber) >= 3:
        dst_map[y][x] = lumber
        result = result or true
      elif current_acre == lumber:
        if count_adjecent(src_map, (x, y), lumber) >= 1 and count_adjecent(src_map, (x, y), tree) >= 1:
          continue
        dst_map[y][x] = open
        result = result or true
