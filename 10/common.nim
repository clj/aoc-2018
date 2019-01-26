type
  Point*[T] = tuple[x, y, vx, vy: T]
  Points*[T] = seq[Point[T]]
  Bounds*[T] = tuple[minx, miny, maxx, maxy: T]

# See: https://github.com/nim-lang/Nim/issues/8390
# for why ratio isn't just `ratio: T = 1`
proc move_sky*[T](points: var Points[T], reverse: bool = false, ratio: float = 1.0): Bounds[T] =
  result.minx = high(T)
  result.miny = high(T)
  result.maxx = low(T)
  result.maxy = low(T)
  for i, point in points:
    if reverse:
      points[i].x = point.x - point.vx * T(ratio)
      points[i].y = point.y - point.vy * T(ratio)
    else:
      points[i].x = point.x + point.vx * T(ratio)
      points[i].y = point.y + point.vy * T(ratio)
    result.minx = min(result.minx, points[i].x)
    result.miny = min(result.miny, points[i].y)
    result.maxx = max(result.maxx, points[i].x)
    result.maxy = max(result.maxy, points[i].y)


proc bounds*[T](points: Points[T]): Bounds[T] =
  result.minx = high(T)
  result.miny = high(T)
  result.maxx = low(T)
  result.maxy = low(T)
  for i, point in points:
    result.minx = min(result.minx, points[i].x)
    result.miny = min(result.miny, points[i].y)
    result.maxx = max(result.maxx, points[i].x)
    result.maxy = max(result.maxy, points[i].y)


when not defined(js):
  import parseutils
  import pegs  # Pegs does not work for javascript :(

  let
    # position=< 9,  1> velocity=< 0,  2>
    pattern = peg"'position=<' \s*{ '-'? \d+ } ',' \s*{ '-'? \d+ } '>' \s* 'velocity=<' \s*{ '-'? \d+ } ',' \s*{ '-'? \d+ } '>'"


  proc parse_integer(s: string): int =
    if s.parse_int(result) == 0:
      echo("Error parsing as int: ", s)
      quit(1)


  proc parse*[T](input: seq[string]): Points[T] =
    for line in input:
      if line =~ pattern:
        var point: Point[T] = (
          x: parse_integer(matches[0]),
          y: parse_integer(matches[1]),
          vx: parse_integer(matches[2]),
          vy: parse_integer(matches[3]))

        result.add(point)