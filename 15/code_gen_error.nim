# For some versions of the compiler this generates
# incorrect code for the js target.

type
  Point = tuple[x, y: int]

var targets = newSeq[tuple[d: int, p: Point]]()
for point in [(x: 1, y: 1), (x: 1, y: 2)]:
  echo($point)
  #let point = point
  targets.add((0, point))
echo($targets)
