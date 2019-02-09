import sequtils
import pegs
import parseutils
import strformat


type
  Point = tuple[x, y: int]
  Scan = tuple[s: Point, e: Point]
  Map = seq[seq[char]]


const
  spring_pos: Point = (500, 0)


proc `$`(map: Map): string =
  for i, line in map:
    stdout.write(fmt"{i:3} ")
    for square in line:
      stdout.write(square)
    stdout.write("\n")


proc find(line: seq[char], target: char, start: int): int =
  for x in start..line.high:
    if line[x] == target:
      return x
  return -1


proc rfind(line: seq[char], target: char, start: int): int =
  for x in countdown(start, 0):
    if line[x] == target:
      return x
  return -1


proc parse_integer(s: string): int =
  if s.parse_int(result) == 0:
    echo("Error parsing as int: ", s)
    writeStackTrace()
    quit(1)


proc parse_scan_line(line: string): Scan =
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


proc render_scan(scan_data: openArray[Scan], height, min_width, max_width: int): Map =
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


proc fill(map: var Map): bool =
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



proc count(map: Map, min_y, max_y: int, things: string): int =
  for y in min_y..max_y:
    for ch in map[y]:
      if ch in things:
        result += 1


var
  input = map(to_seq(stdin.lines), parse_scan_line)
  height = foldl(map_it(input, max(it.s.y, it.e.y)), max(a, b))
  min_height = foldl(map_it(input, min(it.s.y, it.e.y)), min(a, b))
  min_width = foldl(map_it(input, min(it.s.x, it.e.x)), min(a, b))
  max_width = foldl(map_it(input, max(it.s.x, it.e.x)), max(a, b))
  map = render_scan(input, height, min_width, max_width)

echo(map)
var changed = true
while changed:
  changed = fill(map)
  echo(map)
echo(count(map, min_height, height, "|~"))
echo(count(map, min_height, height, "~"))

