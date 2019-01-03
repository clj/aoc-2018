import sequtils
import strutils
import sets
import strformat

import "../lib/parsing.nim"
import "../lib/canvas.nim"

type
  Tool = enum
    torch
    climbing_gear
    neither
  Type = enum
    unknown_type = -1
    rocky
    wet
    narrow
  Region = tuple[geolocial_index, erosion_level: int, cave_type: Type]
  Map = seq[seq[Region]]
  Point = tuple[x, y: int]
  Distance = tuple[dists: array[3, int], prev: Point]
  Distances = seq[seq[Distance]]
  Points = seq[Point]


template `[]`[T](m: seq[seq[T]], p: Point): T =
  m[p.y][p.x]


template `[]=`[T](m: seq[seq[T]], p: Point, v: T) =
  m[p.y][p.x] = v


let
  input = to_seq(stdin.lines)
  depth = parse_integer(input[0][7..^1])
  target_xy = map(input[1][8..^1].split(','), parse_integer)
  target: Point = (target_xy[0], target_xy[1])


var
  map = newSeqWith(target.y+1+100, newSeq[Region](target.x+1+25))


proc reset(map: var Map) =
  for y in 0..map.high:
    for x in 0.. map[0].high:
      var p: Point = (x, y)
      map[p].geolocial_index = -1
      map[p].erosion_level = -1
      map[p].cave_type = unknown_type


proc calculate(map: var Map) =
  let y_mult = 48271
  let x_mult = 16807

  for y in 0..map.high:
    for x in 0.. map[0].high:
      var p: Point = (x, y)
      if p.x == 0 and p.y == 0:
        map[p].geolocial_index = 0
      elif p.x == target.x and p.y == target.y:
        map[p].geolocial_index = 0
      elif p.x == 0:
        map[p].geolocial_index = p.y * y_mult
      elif p.y == 0:
        map[p].geolocial_index = p.x * x_mult
      else:
        assert map[(x: p.x - 1, y: p.y)].erosion_level != -1
        assert map[(x: p.x, y: p.y - 1)].erosion_level != -1
        map[p].geolocial_index = map[(x: p.x - 1, y: p.y)].erosion_level * map[(x: p.x, y: p.y - 1)].erosion_level
      map[p].erosion_level = (map[p].geolocial_index + depth) mod 20183
      map[p].cave_type = Type(map[p].erosion_level mod 3)


proc risk_factor(map: var Map, target: Point): int =
  for y in 0..target.y:
    for x in 0.. target.x:
      var p: Point = (x, y)
      result += int(map[p].cave_type)


proc `render`(m: Map, target: Point): string =
  var canvas = initCanvas(min(m[0].len, 80), min(m.len, 24), 'X')
  for y in 0..m.high:
    for x in 0.. m[0].high:
      if x == 0 and y == 0:
        canvas[x][y] = 'M'
        continue
      if x == target.x and y == target.y:
        canvas[x][y] = 'T'
        continue
      case m[(x: x, y: y)].cave_type
      of rocky: canvas[x][y] = '.'
      of wet: canvas[x][y] = '='
      of narrow: canvas[x][y] = '|'
      else: assert(false)  # Should not happen

  return $canvas


proc cardinal_points(p: Point): Points =
  result = @[(x: p.x, y: p.y - 1), (x: p.x, y: p.y + 1), (x: p.x - 1, y: p.y), (x: p.x + 1, y: p.y)]


proc bounded_cardinal_points(map: Map, p: Point): Points =
  return filter_it(cardinal_points(p), it.x >= 0 and it.y >= 0 and it.x < map[0].len and it.y < map.len)


type
  Node = object
    point: Point
    tool: Tool
    dist: int


proc distances(map: Map, p: Point): Distances =
  result = newSeqWith(map.len, newSeq[Distance](map[0].len))
  for y, row in map:
    for x, tile in row:
      result[(x: x, y: y)] = ([high(int), high(int), high(int)], (-1, -1))
  result[p] = ([0, high(int), high(int)], (-1, -1))

  var
    start = Node(point: p, tool: torch, dist: 0)
    queue = @[start]


  proc valid_tools(cave_type: Type): seq[Tool] =
    case cave_type
    of wet:
      return @[neither, climbing_gear]
    of narrow:
      return @[neither, torch]
    of rocky:
      return @[torch, climbing_gear]
    else: assert false


  proc nodes(m: Map, start: Node, finish: Point): seq[Node] =
    let tools = valid_tools(m[start.point].cave_type).to_set().intersection(valid_tools(m[finish].cave_type).to_set())
    for tool in tools:
      if start.tool == tool:
        result.add(Node(point: finish, tool: tool, dist: 1))
      else:
        result.add(Node(point: start.point, tool: tool, dist: 7))


  proc adjecent_nodes(m: Map, d: Distances, n: Node): seq[Node] =
    let points = bounded_cardinal_points(m, n.point)
    for point in points:
      result &= nodes(m, n, point)
    result = deduplicate(result)


  proc pop_queue(): Node =
    result = queue[0]
    var idx = 0
    for i, value in queue:
      if value.dist < result.dist:
        result = value
        idx = i
    queue.delete(idx)


  while queue.len > 0:
    let node = pop_queue()
    let adjacent_nodes = adjecent_nodes(map, result, node)
    for adjacent_node in adjacent_nodes:
      let d = result[node.point].dists[int(node.tool)] + adjacent_node.dist
      if d < result[adjacent_node.point].dists[int(adjacent_node.tool)]:
        result[adjacent_node.point].dists[int(adjacent_node.tool)] = d
        queue.add(adjacent_node)


map.reset()
map.calculate()
echo(map.render(target))

echo(fmt"Risk level: {map.risk_factor(target)}")

let dists = map.distances((0, 0))
echo(fmt"Fastests time: {dists[target].dists[0]}")

