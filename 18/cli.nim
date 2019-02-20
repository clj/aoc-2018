import sequtils
import strformat
import times

import common

import ../lib/miniterminal


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
  stdout.erase_screen()
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
