import parseutils
import sequtils
import strutils


proc parse_integer(s: string): int =
  if s.parse_int(result) == 0:
    echo("Error parsing as int: ", s)
    quit(1)


let input = map(to_seq(stdin.lines)[0].split(), parse_integer)


proc parse(data: seq[int]): (int, int) =
  let
    num_children = data[0]
    num_metadata = data[1]
  var
    length = 2
    child_values = newSeqOfCap[int](num_children)
    value: int
  for _ in 0..num_children - 1:
    let (child_length, child_value) = parse(data[length..^1])
    length += child_length
    child_values.add(child_value)
  length += num_metadata
  let metadata = data[length-num_metadata..length-1]
  if num_children > 0:
    for _, idx in metadata:
      if idx > 0 and idx < child_values.len + 1:
        value += child_values[idx - 1]
  else:
    value = foldl(metadata, a + b)
  return (length, value)


let (_, value) = parse(input)
echo($value)