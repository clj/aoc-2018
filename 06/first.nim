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

type
  Map = seq[seq[int]]

var
  map = newSeqWith(max_x, newSeq[int](max_y))
  areas = newSeq[Area](coords.len)
  infinite = initSet[int]()

for i, _ in areas:
  areas[i].i = i

for x in 0..max_x-1:
  for y in 0..max_y-1:
    var
      distances = newSeq[Dist](coords.len)
    for i, c in coords:
      distances[i] = (i: i, d: abs(x - c.x) + abs(y - c.y))
    distances.sort do (a, b: Dist) -> int:
      result = cmp(a.d, b.d)
    if distances[0].d == distances[1].d:
      continue  # tie
    areas[distances[0].i].a += 1
    map[x][y] = distances[0].i

for x in 0..max_x-1:
  infinite.incl(map[x][0])
  infinite.incl(map[x][map[0].len - 1])
for y in 0..max_y-1:
  infinite.incl(map[0][y])
  infinite.incl(map[map.len - 1][y])

var
  remove = toSeq(infinite.items())
remove.sort(system.cmp[int], order = SortOrder.Descending)
for i in remove:
  areas.delete(i, i)

# areas.sort(order = SortOrder.Descending) do (a, b: Area) -> int:
#   result = cmp(a.a, b.a)

proc area_cmp(a, b: Area): int =
  result = cmp(a.a, b.a)

areas.sort(area_cmp, order = SortOrder.Descending)
echo areas[0]
