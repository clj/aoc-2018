import sequtils
import algorithm
import sets

type
  NpcKind = enum
    nkGoblin,
    nkElf
  Npc = ref NpcObj
  NpcObj = object
    case kind: NpcKind
      of nkGoblin, nkElf:
        attack: int
        hp: int
        moved: bool
  TileKind = enum
    tkWall,
    tkCavern
  Tile* = ref TileObj
  TileObj = object
    case kind: TileKind
      of tkWall:
        nil
      of tkCavern:
        npc: Npc
  Map* = seq[seq[Tile]]
  Distances = seq[seq[int]]
  Point = tuple[x, y: int]
  Points = seq[Point]
  Area* = object
    map*: Map
    npc_locations: Points
    elves*: int
    goblins*: int


proc `$`*(map: Map): string =
  for row in map:
    for tile in row:
      if tile.kind == tkWall:
        result &= '#'
      else:
        if tile.npc != nil:
          if tile.npc.kind == nkGoblin:
            result &= 'G'
          else:
            result &= 'E'
        else:
          result &= '.'
    result &= "\r\n"


proc output*(map: var Map): string =
  var
    colour: string

  proc change_colour(new_colour: string): string =
    if colour != new_colour:
      result = "\e[" & new_colour & "m"
      colour = new_colour
    else:
      result = ""

  for row in map:
    var npcs: seq[Npc]
    for tile in row:
      if tile.kind == tkWall:
        result &= change_colour("37")
        result &= '#'
      else:
        if tile.npc != nil:
          npcs.add(tile.npc)
          if tile.npc.kind == nkGoblin:
            result &= change_colour("38;2;" & $(tile.npc.hp + 40) & ";0;0")
            result &= 'G'
          else:
            result &= change_colour("38;2;0;" & $(tile.npc.hp + 40) & ";0")
            result &= 'E'
        else:
          result &= change_colour("33")
          result &= '.'
    if npcs.len != 0:
      result &= " <-"
      for npc in npcs:
        if npc.kind == nkGoblin:
          result &= change_colour("38;2;" & $(npc.hp + 40) & ";0;0")
          result &= " G:" & $npc.hp
        else:
          result &= change_colour("38;2;0;" & $(npc.hp + 40) & ";0")
          result &= " E:" & $npc.hp
    result &= "\r\n"


proc `$`*(x: Distances): string =
  for row in x:
    for tile in row:
      if tile == -1:
        result &= "*"
      elif tile == high(int):
        result &= "?"
      elif tile <= 9:
        result &= $tile
      else:
        result &= "+"
    result &= "\r\n"


template cardinal_points(p: Point): untyped =
  # In reading order!
  [(x: p.x, y: p.y + 1), (x: p.x - 1, y: p.y), (x: p.x + 1, y: p.y), (x: p.x, y: p.y - 1)]


proc manhattan_distances(map: var Map, p: Point): Distances =
  var
    queue = newSeq[Point]()

  result = newSeqWith(map.len, newSeq[int](map[0].len))
  for y, row in map:
    for x, tile in row:
      if tile.kind == tkWall:
        result[y][x] = -1
      else:
        if tile.npc != nil:
          result[y][x] = -1
        else:
          result[y][x] = high(int)

  result[p.y][p.x] = 0

  proc queue_points(m: var Map, p: Point) =
    for point in cardinal_points(p):
      if point.x < 0 or point.x > m.high or p.y < 0 or p.y > m[0].high:
        continue
      if m[point.y][point.x].kind == tkCavern and m[point.y][point.x].npc == nil:
        queue.add(point)

  proc min_distance(m: var Map, d: Distances, p: Point): int =
    result = -1
    for point in cardinal_points(p):
      if point.x < 0 or point.x > m.high or p.y < 0 or p.y > m[0].high:
        continue
      if d[point.y][point.x] >= 0 and (result == -1 or d[point.y][point.x] < result):
        result = d[point.y][point.x]

  queue_points(map, (x: p.x, y: p.y))

  while queue.len > 0:
    let current_point = queue.pop()
    let min_distance = min_distance(map, result, current_point)
    if min_distance >= 0:
      let distance = min_distance + (if min_distance == high(int): 0 else: 1)
      if distance < result[current_point.y][current_point.x]:
        result[current_point.y][current_point.x] = distance
        queue_points(map, current_point)


proc init*(area: var Area, input: seq[string], attack: int) =
  let
    height = input.len
    width = input[0].len
  area.map = newSeqWith(height, newSeq[Tile](width))
  area.npc_locations = @[]
  area.elves = 0
  area.goblins = 0
  # Initialise map
  for y, line in input:
    for x, ch in line:
      if ch == '#':
        area.map[y][x] = Tile(kind: tkWall)
      else:
        area.map[y][x] = Tile(kind: tkCavern)
        if ch == 'G':
          area.map[y][x].npc = Npc(kind: nkGoblin, attack: 3, hp: 200)
          area.npc_locations.add((x, y))
          area.goblins += 1
        elif ch == 'E':
          area.map[y][x].npc = Npc(kind: nkElf, attack: attack, hp: 200)
          area.npc_locations.add((x, y))
          area.elves += 1


proc move_npc(area: var Area, kind: NpcKind, src: Point): Point =
  if area.map[src.y][src.x].npc.moved:
    return src
  var can_move = false
  for point in cardinal_points(src):
      if point.x < 0 or point.x > area.map.high or point.y < 0 or point.y > area.map[0].high:
        continue
      if area.map[point.y][point.x].kind == tkWall or area.map[point.y][point.x].npc != nil:
        continue
      can_move = true
      break
  if not can_move:
    return src
  let dists = manhattan_distances(area.map, src)
  var targets = newSeqOfCap[tuple[d: int, p: Point]](area.npc_locations.len * 4)
  for npc_loc in area.npc_locations:
    if area.map[npc_loc.y][npc_loc.x].npc == nil or area.map[npc_loc.y][npc_loc.x].npc.kind == kind:
      continue
    for point in cardinal_points(npc_loc):
      if point.x < 0 or point.x > area.map.high or point.y < 0 or point.y > area.map[0].high:
        continue
      if area.map[point.y][point.x].kind == tkWall or area.map[point.y][point.x].npc != nil:
        continue
      let point = point # otherwise things break in interesting ways in js with nim 0.19.4
      targets.add((dists[point.y][point.x], point))
  if targets.len == 0:
    return src
  targets.sort do (a, b: auto) -> int:
    result = cmp(a.d, b.d)
    if result == 0:
      result = cmp(a.p.y, b.p.y)
      if result == 0:
        result = cmp(a.p.x, b.p.x)
  let target_pos = targets[0].p
  let target_dists = manhattan_distances(area.map, target_pos)
  var
    dist = high(int)
    dst: Point
  for point in cardinal_points(src):
      if point.x < 0 or point.x > area.map.high or point.y < 0 or point.y > area.map[0].high:
        continue
      if area.map[point.y][point.x].kind == tkWall or area.map[point.y][point.x].npc != nil:
        continue
      if dist == high(int) or target_dists[point.y][point.x] <= dist:
        dist = target_dists[point.y][point.x]
        dst = point
  if dist == high(int):
    return src  # No reachable candidates

  area.map[dst.y][dst.x].npc = area.map[src.y][src.x].npc
  area.map[src.y][src.x].npc = nil
  area.map[dst.y][dst.x].npc.moved = true
  return (dst.x, dst.y)


proc attack(area: var Area, p: Point): Npc =
  let
    attacker = area.map[p.y][p.x].npc
    kind = attacker.kind
  var
    target: Npc
    target_pos: Point
  for point in cardinal_points(p):
    if point.x < 0 or point.x > area.map.high or point.y < 0 or point.y > area.map[0].high:
      continue
    if area.map[point.y][point.x].kind == tkWall:
      continue
    let npc = area.map[point.y][point.x].npc
    if npc != nil and npc.kind != kind:
      if target == nil:
        target = npc
        target_pos = point
      elif target.hp >= npc.hp:
        target = npc
        target_pos = point
  if target == nil:
    return
  target.hp -= attacker.attack
  if target.hp <= 0:
    result = area.map[target_pos.y][target_pos.x].npc
    area.map[target_pos.y][target_pos.x].npc = nil
    if result.kind == nkElf:
      area.elves -= 1
    else:
      area.goblins -= 1


proc remaining_hitpoints*(map: var Map): int =
  for y in 0..map.len-1:
    for x in 0..map[0].len-1:
      if map[y][x].kind == tkCavern and map[y][x].npc != nil:
        result += map[y][x].npc.hp


proc round*(area: var Area, finish_on_dead_elf: bool): bool =
  area.npc_locations.sort do (a, b: auto) -> int:
    result = cmp(a.y, b.y)
    if result == 0:
      result = cmp(a.x, b.x)

  for i in countdown(area.npc_locations.high, 0):
    let pos = area.npc_locations[i]
    if area.map[pos.y][pos.x].npc == nil:
      area.npc_locations.delete(i)
    else:
      area.map[pos.y][pos.x].npc.moved = false

  for i in 0..area.npc_locations.high:
    let pos = area.npc_locations[i]
    let npc = area.map[pos.y][pos.x].npc
    if npc == nil:
      continue
    proc has_enemy(map: var Map, p: Point): bool =
      for point in cardinal_points(p):
        if point.x < 0 or point.x > map.high or p.y < 0 or p.y > map[0].high:
          continue
        if map[point.y][point.x].kind == tkWall:
          continue
        let target_npc = map[point.y][point.x].npc
        if target_npc != nil and target_npc.kind != npc.kind:
          return true
      return false
    if not has_enemy(area.map, pos):
      if area.elves == 0 or area.goblins == 0:
        return true
      area.npc_locations[i] = move_npc(area, npc.kind, pos)
    let dead = attack(area, area.npc_locations[i])
    if finish_on_dead_elf and dead != nil and dead.kind == nkElf:
      return true

  return false
