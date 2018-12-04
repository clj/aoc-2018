import algorithm
import parseutils
import pegs
import sequtils
import tables


type
  Hours = CountTable[int]

var
  input = to_seq(stdin.lines)
  guards = initTable[string, Hours]()
  current_guard = ""
  sleep_start = -1

let
  timestamp = peg"'[' \d\d\d\d '-' \d\d '-' \d\d ' ' \d\d ':' { \d\d } ']'"


sort(input, system.cmp)


for line in input:
  # [1518-10-12 23:58] Guard #421 begins shift
  if line =~ sequence(timestamp, peg" \s+ 'Guard #' { \d+ }"):
    current_guard = matches[1]
    if not (current_guard in guards):
      guards[current_guard] = initCountTable[int]()
  # [1518-03-23 00:19] falls asleep
  elif line =~ sequence(timestamp, peg" \s+ 'falls asleep'"):
    discard matches[0].parse_int(sleep_start)
  # [1518-07-18 00:14] wakes up
  elif line =~ sequence(timestamp, peg" \s+ 'wakes up'"):
    var sleep_end: int
    discard matches[0].parse_int(sleep_end)
    for i in sleep_start..sleep_end:
      guards[current_guard][i] = guards[current_guard].getOrDefault(i) + 1

var
  sleepiest_guard_id = ""
  sleepiest_hours: Hours
  max_sleep_time = 0

for guard_id, hours in guards:
  if hours.len == 0:
    continue
  let current_sleep_time = foldl(to_seq(values(hours)), a + b)
  if current_sleep_time > max_sleep_time:
    max_sleep_time = current_sleep_time
    sleepiest_guard_id = guard_id
    sleepiest_hours = hours

echo("Strategy 1:")
echo("  id:                     " & sleepiest_guard_id)
echo("  minutes slept:          " & $max_sleep_time)
echo("  sleepiest minute:       " & $sleepiest_hours.largest()[0])
echo("  sleepiest minute count: " & $sleepiest_hours.largest()[1])

var int_guard_id: int
discard sleepiest_guard_id.parse_int(int_guard_id)
echo("  result:                 " & $(int_guard_id * sleepiest_hours.largest()[0]))


var
  max_sleep_minute = -1
  max_sleep_count = 0

for guard_id, hours in guards:
  if hours.len == 0:
    continue
  let (minute, count) = hours.largest()
  if count > max_sleep_count:
    sleepiest_guard_id = guard_id
    max_sleep_minute = minute
    max_sleep_count = count

echo("Strategy 2:")
echo("  id:                     " & sleepiest_guard_id)
echo("  sleepiest minute:       " & $max_sleep_minute)
echo("  sleepiest minute count: " & $max_sleep_count)

discard sleepiest_guard_id.parse_int(int_guard_id)
echo("  result:                 " & $(int_guard_id * max_sleep_minute))
