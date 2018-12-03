import sequtils
import strutils

var input = to_seq(stdin.lines)
var rest = input

for i, line in input:
  rest = rest[1..^1]
  for j, line_two in rest:
    var
      diff_pos = -1
      j = j + i + 1

    for pos, val in zip(line, line_two):
      let (a, b) = val
      if a != b:
        if diff_pos != -1:
          diff_pos = -1
          break
        diff_pos = pos
    if diff_pos == -1:
      continue

    echo($i & " " & $(j + i + 1) & " pos:" & $diff_pos)
    echo(' '.repeat(diff_pos) & 'v')
    echo(line)
    echo(line_two)
    echo(' '.repeat(diff_pos) & '^')
    echo(line[0..diff_pos - 1], line[diff_pos + 1..^1])
