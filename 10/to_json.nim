import json
import sequtils

import common


proc `%`[T](p: Point[T]): JsonNode =
  result = %[p.x, p.y, p.vx, p.vy]

# the pegs module doesn't work in js
# output json that can be embedded into
# the page instead
echo(%parse[int](to_seq(stdin.lines)))
