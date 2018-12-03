import parseutils
import sets
import sequtils

var freq = 0
let input = to_seq(stdin.lines)
var freqs = initSet[int]()


iterator forever(sequence: seq[int]): int =
  while true:
    for item in sequence:
      yield item


proc to_int(s: string): int =
  discard s.parse_int(result)


for number in forever(input.map_it(to_int(it))):
  freq += number
  if freq in freqs:
    echo(freq)
    quit(0)
  freqs.incl(freq)
