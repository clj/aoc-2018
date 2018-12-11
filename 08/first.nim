import parseutils
import sequtils
import strutils


proc parse_integer(s: string): int =
  if s.parse_int(result) == 0:
    echo("Error parsing as int: ", s)
    quit(1)


let input = map(to_seq(stdin.lines)[0].split(), parse_integer)


proc parse(data: seq[int]): (int, seq[int]) =
  var
    length = 2
    metadata: seq[int]
  let
    num_children = data[0]
    num_metadata = data[1]
  for _ in 0..num_children - 1:
    let (child_length, child_metadata) = parse(data[length..^1])
    length += child_length
    metadata &= child_metadata
  length += num_metadata
  metadata = data[length-num_metadata..length-1] & metadata
  return (length, metadata)


let (_, metadata) = parse(input)
echo($foldl(metadata, a + b))