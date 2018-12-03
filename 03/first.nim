import strutils
import macros
import parseutils


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
  Fabric[W, H: static[int]] =
    array[0..W, array[0..H, int]]

var
  fabric: Fabric[1000, 1000]
  overlap = 0

for line in stdin.lines:
  # "#1 @ 1,3: 4x4"
  var xy, wh, xx, yy, ww, hh: string
  (_, _, xy, _, wh) ..= line.split({' ', ':'})
  (xx, yy) ..= xy.split(',')
  (ww, hh) ..= wh.split('x')
  var x, y, w, h: int
  discard xx.parse_int(x)
  discard yy.parse_int(y)
  discard ww.parse_int(w)
  discard hh.parse_int(h)
  #echo($x & " " & $y & " " & $w & " " & $h)
  for i in x..x + w - 1:
    for j in y..y + h - 1:
      fabric[i][j] += 1
      if fabric[i][j] == 2:
        overlap += 1

echo(overlap)
