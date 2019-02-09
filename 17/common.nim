import sequtils
import pegs
import parseutils
import strformat

type
  Point* = tuple[x, y: int]
  Points* = seq[Point]
  Scan = tuple[s: Point, e: Point]
  Map* = seq[seq[char]]


const
  spring_pos*: Point = (500, 0)


proc output*[T](map: Map, file: T, offset: int = -1) =
  for i, line in map:
    if offset != -1:
      file.write(fmt"{i+offset:5} ")
    for square in line:
      file.write(square)
    file.write("\r\n")


template `[]`*(map: var Map, point: Point): char =
  map[point.y][point.x]


template `[]=`*(map: var Map, point: Point, val: char) =
  map[point.y][point.x] = val


proc `+`*(a, b: Point): Point {. inline .} =
  return (x: a.x + b.x, y: a.y + b.y)


proc `-`*(a, b: Point): Point {. inline .} =
  return (x: a.x - b.x, y: a.y - b.y)


proc find(line: seq[char], target: char, start: int, `end`: int = -1): int =
  for x in start..(if `end` == -1: line.high else: `end`):
    if line[x] == target:
      return x
  return -1


proc rfind(line: seq[char], target: char, start: int, `end`: int = 0): int =
  for x in countdown(start, `end`):
    if line[x] == target:
      return x
  return -1


proc find_all(line: seq[char], target: char, start, `end`: int): seq[int] =
  for x in start..`end`:
    if line[x] == target:
      result.add(x)
  return


proc parse_integer(s: string): int =
  if s.parse_int(result) == 0:
    echo("Error parsing as int: ", s)
    writeStackTrace()
    quit(1)


proc parse_scan_line*(line: string): Scan =
  # x=495, y=2..7
  let parser = peg"{\w+} \s* '=' \s* {\d+} \s* ',' \s* {\w+} \s* '=' \s* {\d+} \s* '..' \s* {\d+}"

  if line =~ parser:
    if matches[0] == "x":
      result.s.x = parse_integer(matches[1])
      result.s.y = parse_integer(matches[3])
      result.e.x = parse_integer(matches[1])
      result.e.y = parse_integer(matches[4])
    else:
      result.s.x = parse_integer(matches[3])
      result.s.y = parse_integer(matches[1])
      result.e.x = parse_integer(matches[4])
      result.e.y = parse_integer(matches[1])
  else:
    echo("error parsing: " & line)
    quit(1)


proc render_scan*(scan_data: openArray[Scan], height, min_width, max_width: int): Map =
  let width = max_width - min_width + 3
  result = newSeqWith(height + 1, newSeq[char](width))
  for y in 0..result.high:
    for x in 0..result[0].high:
      result[y][x] = '.'
  result[spring_pos.y][spring_pos.x - min_width] = '+'
  for line in scan_data:
    if line.s.x == line.e.x:
      for y in line.s.y..line.e.y:
        let x = line.s.x - min_width + 1
        result[y][x] = '#'
    else:
      for x in line.s.x..line.e.x:
        let y = line.s.y
        let x = x - min_width + 1
        result[y][x] = '#'


proc fill*(map: var Map): bool =
  for y in 0..map.high - 1:
    for x, ch in map[y]:
      if (ch == '|' or ch == '+') and map[y + 1][x] == '.':
        map[y + 1][x] = '|'
        result = true
      elif (ch == '|' or ch == '+') and map[y + 1][x]in "#~":
        let min_x = map[y].rfind('#', x-1)
        let max_x = map[y].find('#', x+1)
        let required_width = max_x - min_x - 1
        if y + 1 < map.len and min_x != -1 and max_x != -1 and min_x != -1 and min_x != max_x:
          let floor = map[y + 1][min_x+1..max_x-1]
          if floor.count('#') == required_width or floor.count('~') == required_width:
            for x in min_x+1..max_x-1:
              map[y][x] = '~'
            result = true
          if map[y][min_x+1..max_x-1].count('|') == required_width:
            for x in min_x+1..max_x-1:
              map[y][x] = '~'
            result = true
        if map[y][x - 1] == '.' and (map[y + 1][x - 1] in "#~" or map[y + 1][x] == '#'):
          map[y][x - 1] = '|'
          result = true
        if map[y][x + 1] == '.' and (map[y + 1][x + 1] in "#~" or map[y + 1][x] == '#'):
          map[y][x + 1] = '|'
          result = true


proc anim_fill*(map: var Map): bool =
  var
    changed: Points

  template `[]=`(map: var Map, point: Point, val: char) =
    map[point.y][point.x] = val
    changed.add(point)

  for y in 0..map.high - 1:
    for x, ch in map[y]:
      let
        point: Point = (x: x, y: y)
        over = point - (x: 0, y: 1)
        under = point + (x: 0, y: 1)
        left = point - (x: 1, y: 0)
        right = point + (x: 1, y: 0)
      if point in changed: continue
      if (ch == '|' or ch == '+') and map[under] == '.':
        map[under] = '|'
        result = true
      elif (ch == '|' or ch == '+') and map[y + 1][x]in "#~":
        let min_x = map[y].rfind('#', x-1)
        let max_x = map[y].find('#', x+1)
        let required_width = max_x - min_x - 1
        if y + 1 < map.len and min_x != -1 and max_x != -1 and min_x != -1 and min_x != max_x:
          let floor = map[y + 1][min_x+1..max_x-1]
          if floor.count('#') + floor.count('~') == required_width:
            for x in min_x+1..max_x-1:
              if map[(x: x, y: y)] == '.' and (map[(x: x - 1, y: y)] == '|' or map[(x: x + 1, y: y)] == '|'):
                if (x: x - 1, y: y) in changed or (x: x + 1, y: y) in changed: continue
                map[(x: x, y: y)] = '|'
            result = true
          if map[y][min_x+1..max_x-1].count('|') == required_width:
            for x in min_x+1..max_x-1:
              map[y][x] = '~'
            result = true
        if map[left] == '.' and (map[y + 1][x - 1] in "#~" or map[y + 1][x] == '#'):
          if point in changed: continue
          map[left] = '|'
          result = true
        if map[right] == '.' and (map[y + 1][x + 1] in "#~" or map[y + 1][x] == '#'):
          if point in changed: continue
          map[right] = '|'
          result = true


proc count*(map: Map, min_y, max_y: int, things: string): int =
  for y in min_y..max_y:
    for ch in map[y]:
      if ch in things:
        result += 1


proc lowest*(map: var Map, min_y, max_y: int, things: string): int =
  for y in min_y..max_y:
    for ch in map[y]:
      if ch in things:
        result = y
        break
