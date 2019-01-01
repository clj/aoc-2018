import sequtils
import strutils
import strformat
import tables
import sets

import "../lib/parsing.nim"


type
  Point = array[4, int]
  Points = seq[Point]
  PointSet = HashSet[Point]


proc parse_line(line: string): Point =
  let parsed = map(map_it(line.split(',')[0..3], it.strip()), parse_integer)
  for i in 0..high(Point):
    {.unroll.}
    result[i] = parsed[i]


proc manhattan_distance(a, b: Point): int =
  for i in 0..a.high:
    result += abs(b[i] - a[i])


proc constellations(points: Points, distance: int): seq[Points] =
  var groups = initTable[Point, PointSet]()
  for a in points:
    for b in points:
      if a == b:
        continue
      let d = manhattan_distance(a, b)
      if not (a in groups):
        let group = initSet[Point]()
        groups[a] = group
      if d > distance:
        continue
      groups[a].incl(b)
  var constellations: seq[PointSet]
  var queue: seq[Point]
  while groups.len > 0 or queue.len > 0:
    if queue.len == 0:
      constellations.add(PointSet())
      constellations[^1].init()
      queue.add(to_seq(groups.keys)[0])
    let point = queue.pop()
    var value: PointSet
    if not groups.take(point, value):
      continue  # already processed
    constellations[^1] = union(constellations[^1], value)
    queue &= to_seq(value.items)

  return map_it(constellations, to_seq(it.items))


var
  input = to_seq(stdin.lines)
  points = map(input, parse_line)


echo(fmt"# of constellations: {constellations(points, 3).len}")
