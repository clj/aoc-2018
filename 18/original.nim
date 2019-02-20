import strutils
import strformat
import sequtils
import terminal
import times

const
  open = '.'
  tree = '|'
  lumber = '#'


type
  Map = seq[seq[char]]
  Point = tuple[x, y: int]
  Points = seq[Point]


proc clear_screen() =
  stdout.write("\E[H\E[2J")
  stdout.flushFile()


proc `$`(map: Map): string =
  stdout.write("    ")
  for i in 0..map.high:
    stdout.write(fmt"{i%%10}")
  stdout.write("\n")
  for i, line in map:
    stdout.write(fmt"{i:3} ")
    for square in line:
      stdout.write(square)
    stdout.write("\n")


proc input_to_map(input: openarray[string]): Map =
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


proc iterate(src_map: Map, dst_map: var Map): bool =
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


proc count(map: Map, typ: char): int =
  for y in 0..map.high:
    for x in 0..map[0].high:
      if map[y][x] == typ:
        result += 1


var
  input = to_seq(stdin.lines)
  maps = newSeq[Map](2)


maps[0] = input_to_map(input)
maps[1] = newSeqWith(maps[0][0].len, newSeq[char](maps[0].len))


var
  i = 0

echo(maps[0])
while i < 10:
  if not iterate(maps[i %% 2], maps[(i + 1) %% 2]):
    continue
  i += 1
  clear_screen()
  echo(fmt"generation: {i}")
  echo(maps[i %% 2])

let lumberyards = count(maps[i %% 2], lumber)
let wooded = count(maps[i %% 2], tree)
echo(fmt"{lumberyards} * {wooded} = {lumberyards * wooded}")

const large_iterations = 1000000000

var answers = newSeqOfCap[int](10000)
let start = cpu_time()
while i < large_iterations:
  if not iterate(maps[i %% 2], maps[(i + 1) %% 2]):
    break
  i += 1

  let duration = cpu_time() - start
  let rate = float(i)/duration
  stdout.write(fmt("\rgeneration: {i} {rate}"))
  stdout.flush_file()
  let lumberyards = count(maps[i %% 2], lumber)
  let wooded = count(maps[i %% 2], tree)
  answers.add(lumberyards * wooded)
  const min_region = 5
  if answers.len > min_region * 2:
    for n in min_region..answers.high:
      if n * 2 + min_region > answers.len:
        break
      let region = answers[answers.high - n..answers.high]
      let matches_area = answers[answers.high - region.high * 2..answers.high - region.high]
      assert(matches_area.len == region.len, fmt"{matches_area.len} != {region.len}")
      if matches_area == region:
        echo()
        echo(fmt"Found repeating sequence after {i} iterations")
        echo(region[(large_iterations - i) %% (region.len - 1)])
        quit(0)
echo(fmt"{lumberyards} * {wooded} = {lumberyards * wooded}")
