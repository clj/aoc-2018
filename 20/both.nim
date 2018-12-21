import parseopt
import tables
import strutils
import strformat
import sequtils
import terminal
import os
import times
import sets

import "../lib/parsing"
import "../lib/miniterminal.nim"
import "../lib/canvas.nim"


type
  Options = object
    map: bool
    render: bool
    record: bool
    recording_width: int
    recording_height: int
  Direction = enum
    north, east, south, west
  Room = ref object
    doors: array[Direction, Room]
    coordinate: Point
    distance: int
  Point = tuple[x: int, y: int]
  Rooms = TableRef[Point, Room]
  RegexNode = ref object
    str: string
    children: seq[RegexNode]

# ^ENWWW(NEEE|SSE(EE|N)WWW)NNN(E|W)$

# ENWWW-----
# |    \    \
# NEEE  SSE  NNN
#       |  \   |\
#       EE  N  E W
#       |    \
#       WWW   WWW


const
  directions: array[4, Point] = [(0, -1), (1, 0), (0, 1), (-1, 0)]

let
  canvas_width = terminal_width() - 1
  canvas_height = terminal_height() - 1

var
  options: Options


proc `+`(p1, p2: Point): Point {.inline.} =
  return (p1.x + p2.x, p1.y + p2.y)


proc `+`(d: Direction, p: Point): Point {.inline.} =
  return p + directions[int(d)]


proc `+`(p: Point, d: Direction): Point {.inline.} =
  return d + p


proc `+`(d: Direction, i: int): Direction {.inline.} =
  return Direction((int(d) + i) %% 4)


proc `-`(d: Direction, i: int): Direction {.inline.} =
  return Direction((int(d) - i) %% 4)


proc render_room(canvas: Canvas, room: Room, cp: Point, resolved: bool) =
  for cxo in -1..1:
    for cyo in -1..1:
      if cxo == 0 and cyo == 0:
        continue
      let direction_idx = directions.find((cxo, cyo))
      if direction_idx != -1:
        let direction = Direction(direction_idx)
        if room.doors[direction] != nil:
          var door = '|'
          if direction in [north, south]:
            door = '-'
          canvas[cp.x + cxo][cp.y + cyo] = door
          continue
      if not resolved and (cxo == 0 or cyo == 0):
        canvas[cp.x + cxo][cp.y + cyo] = '?'
        continue
      canvas[cp.x + cxo][cp.y + cyo] = '#'


proc render(rooms: Rooms, origin: Point, width, height: int, resolved: bool): string =
  var canvas = initCanvas(width, height, '.')

  for cx in countup(1, width - 1, 2):
    for cy in countup(1, height - 1, 2):
      let rx = (cx div 2) - (width div 4) + origin.x
      let ry = (cy div 2) - (height div 4) + 1 + origin.y
      if not ((rx, ry) in rooms):
        continue
      canvas.render_room(rooms[(rx, ry)], (cx, cy), resolved)
      if (rx, ry) == (0, 0):
        canvas[cx][cy] = 'X'
      elif (rx, ry) == origin:
        canvas[cx][cy] = '@'
  return $canvas


proc add(rooms: Rooms, p: Point, direction: Direction): Room =
  let room = rooms[p]
  let new_room = new Room
  let new_coords = p + direction
  new_room.coordinate = new_coords
  new_room.distance = high(int)
  rooms[new_coords] = new_room
  room.doors[direction] = new_room
  new_room.doors[direction + 2] = room
  return new_room


proc add(rooms: Rooms, room: Room, direction: Direction): Room =
  return rooms.add(room.coordinate, direction)


proc traverse(node: RegexNode, start: Room, fn: proc(start: Room, s: string): Room) =
  var visit = newSeqOfCap[tuple[n: RegexNode, s: Room]](1000)
  var seen = newSeq[RegexNode]()
  visit.add((node, start))
  while visit.len > 0:
    var (n, s) = visit.pop()
    if n in seen:
      continue
    seen.add(n)
    if n.str.len != 0:
      s = fn(s, n.str)
    for c in n.children:
      visit.add((c, s))


proc count(node: RegexNode): int =
  var visit = newSeqOfCap[RegexNode](1000)
  var seen = newSeq[RegexNode]()
  visit.add(node)
  while visit.len > 0:
    let n = visit.pop()
    if n in seen:
      stdout.write(fmt("\nSeen: {n.str} {result}\n"))
      continue
    seen.add(n)
    stdout.write(fmt("\r{visit.len}"))
    stdout.flush_file()
    result += 1
    for c in n.children:
      visit.add(c)


proc parse(str: string): RegexNode =
  var node = new RegexNode
  let left_paren = str.find('(')
  if left_paren != -1:
    node.str = str[0..left_paren - 1]
  else:
    node.str = str
    return node
  var
    i = left_paren + 1
    p = 1
    s = i
    sub = newSeq[string]()
  while p > 0:
    if str[i] == '(':
      p += 1
    elif str[i] == ')':
      p -= 1
      if p == 0:
        sub.add(str[s..i-1])
    elif p == 1 and str[i] == '|':
      sub.add(str[s..i-1])
      s = i+1
    i += 1
  node.children = map(sub, parse)
  if i < str.len:
    let rest = parse(str[i..^1])
    node.children.add(rest)
  return node


proc ch_to_direction(ch: char): Direction {.inline.} =
  case ch
    of 'N': return north
    of 'E': return east
    of 'S': return south
    of 'W': return west
    else: assert(false)  # Should not happen


proc walk(start: Room, directions: string, rooms: var Rooms): Room =
  var current_room = start
  for ch in directions:
    let direction = ch_to_direction(ch)
    let door = current_room.doors[direction]
    if door == nil:
      current_room = rooms.add(current_room, direction)
    else:
      current_room = door
  if options.render:
    stdout.eraseScreen()
    stdout.setCursorPos(0, 0)
    stdout.write(render(rooms, current_room.coordinate, canvas_width, canvas_height, false))
    stdout.flush_file()
    sleep(1)
  return current_room


proc distances(start: Room) =
  var
    queue = newSeq[Room]()

  start.distance = 0

  proc queue_rooms(room: Room) =
    for door in room.doors:
      if door != nil:
        queue.add(door)

  proc get_distance(room: Room): int =
    if room == nil:
      return -1
    return room.distance

  queue_rooms(start)

  while queue.len > 0:
    let current_room = queue.pop()
    let distances = filter_it(map(current_room.doors, get_distance), it >= 0)
    if distances.len > 0:
      let distance = min(distances) + 1
      if distance < current_room.distance:
        current_room.distance = distance
        queue_rooms(current_room)


let
  input = toSeq(stdin.lines)[0][1..^2]

var
  start: Room
  rooms: Rooms = newTable[Point, Room]()
  walks = 0

var p = initOptParser()
for kind, key, val in p.getopt():
  case kind
  of cmdArgument:
    assert(false)
  of cmdLongOption, cmdShortOption:
    case key
    of "map", "m": options.map = true
    of "render": options.render = true
    # of "record", "r": options.record = true
    # of "width", "w": options.recording_width = parse_integer(val)
    # of "height", "h": options.recording_height = parse_integer(val)
  of cmdEnd: assert(false) # cannot happen


start = new Room
start.coordinate = (0, 0)
rooms[(0, 0)] = start

proc walker(start: Room, s: string): Room =
  walks += 1
  return walk(start, s, rooms)

traverse(parse(input), start, walker)

if options.map:
  stdout.write(render(rooms, (0, 0), 250, 211, true))
  quit(0)


stdout.eraseScreen()
stdout.setCursorPos(0, 0)
stdout.write(render(rooms, (0, 0), canvas_width, canvas_height, true))
stdout.cursorUp(4)
echo(fmt("                                   "))
echo(fmt"no. routes:                {walks:<8d}")

distances(start)

var d = 0
var s1000 = 0
for _, room in rooms:
  if room.distance >= 1000:
    s1000 += 1
  d = max(d, room.distance)
echo(fmt"max doors to reach a room: {d:<8d}")
echo(fmt"rooms passing 1000+ doors: {s1000:<8d}")
