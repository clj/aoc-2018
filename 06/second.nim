import algorithm
import macros
import parseutils
import sequtils
import sets
import strutils

# From: https://stackoverflow.com/questions/31948131/unpack-multiple-variables-from-sequence
macro `..=`*(lhs: untyped, rhs: tuple|seq|array): auto =
  # Check that the lhs is a tuple of identifiers.
  expectKind(lhs, nnkPar)
  for i in 0..len(lhs)-1:
    expectKind(lhs[i], nnkIdent)
  # Result is a statement list starting with an
  # assignment to a tmp variable of rhs.
  let t = genSym()
  result = newStmtList(quote do:
    let `t` = `rhs`)
  # assign each component to the corresponding
  # variable.
  for i in 0..len(lhs)-1:
    let v = lhs[i]
    # skip assignments to _.
    if $v.toStrLit != "_":
      result.add(quote do:
        `v` = `t`[`i`])

type
  Coord = tuple[x, y: int]
  Dist = tuple[i, d: int]
  Area = tuple[i, a: int]

let input = to_seq(stdin.lines)
var
  coords = newSeqOfCap[Coord](input.len)
  max_x = 0
  max_y = 0

for i, line in input:
  var
    xx, yy: string
    c: Coord
  (xx, yy) ..= line.split(',')
  discard xx.strip().parse_int(c.x)
  discard yy.strip().parse_int(c.y)
  coords.add(c)
  max_x = max(max_x, c.x)
  max_y = max(max_y, c.y)

var
  area = 0

const
  max_dist = 10000

for x in 0..max_x-1:
  for y in 0..max_y-1:
    var
      distance = 0
    for i, c in coords:
      distance += abs(x - c.x) + abs(y - c.y)
    if not (distance < max_dist):
      continue  # too far
    area += 1

echo area
