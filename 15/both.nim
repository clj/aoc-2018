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
  TileKind = enum
    tkWall,
    tkCavern
  Tile = ref TileObj
  TileObj = object
    case kind: TileKind
      of tkWall:
        nil
      of tkCavern:
        npc: NPC
  Map = seq[seq[Tile]]
  Distances = seq[seq[int]]
  Point = tuple[x, y: int]
  Points = seq[Point]


let
  input = to_seq(stdin.lines)
  height = input.len
  width = input[0].len


var
  map = newSeqWith(height, newSeq[Tile](width))


proc `$`(map: Map): string =
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
    result &= "\n"


proc `$`(x: Distances): string =
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
    result &= "\n"


proc cardinal_points(p: Point): Points =
  result = @[(x: p.x, y: p.y - 1), (x: p.x, y: p.y + 1), (x: p.x - 1, y: p.y), (x: p.x + 1, y: p.y)]


proc bounded_cardinal_points(map: Map, p: Point): Points =
  return filter_it(cardinal_points(p), it.x >= 0 and it.y >= 0 and it.x < map.len and it.y < map[0].len)


proc non_obstacle_cardinal_points(map: Map, p: Point): Points =
  return filter_it(bounded_cardinal_points(map, p), not (map[it.y][it.x].kind == tkWall or map[it.y][it.x].npc != nil))


proc manhattan_distances(map: Map, p: Point): Distances =
  var
    queue = newSeq[Point]()

  result = newSeqWith(height, newSeq[int](width))
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

  proc queue_points(m: Map, p: Point) =
    queue.add(non_obstacle_cardinal_points(m, p))

  proc distances(m: Map, d: Distances, p: Point): seq[int] =
    return filter_it(map_it(bounded_cardinal_points(m, p), d[it.y][it.x]), it >= 0)

  queue_points(map, (x: p.x, y: p.y))

  while queue.len > 0:
    let current_point = queue.pop()
    let distances = distances(map, result, current_point)
    if distances.len > 0:
      let distance = min(distances) + 1
      if distance < result[current_point.y][current_point.x]:
        result[current_point.y][current_point.x] = distance
        queue_points(map, current_point)


proc adjacent_target_squares(my_kind: NpcKind, map: Map): Points =
  for y, row in map:
    for x, tile in row:
      if tile.kind == tkCavern:
        if tile.npc != nil:
          if tile.npc.kind != my_kind:
            result &= non_obstacle_cardinal_points(map, (x: x, y: y))


proc init(attack: int) =
  # Initialise map
  for y, line in input:
    for x, ch in line:
      if ch == '#':
        map[y][x] = Tile(kind: tkWall)
      else:
        map[y][x] = Tile(kind: tkCavern)
        if ch == 'G':
          map[y][x].npc = Npc(kind: nkGoblin, attack: 3, hp: 200)
        elif ch == 'E':
          map[y][x].npc = Npc(kind: nkElf, attack: attack, hp: 200)


proc move_npc(map: Map, kind: NpcKind, src: Point): Point =
  let dists = manhattan_distances(map, src)
  let target_squares = adjacent_target_squares(kind, map)
  if target_squares.len == 0:
    return src
  let z = zip(map_it(target_squares, dists[it.y][it.x]), target_squares)
  let min_dist = min(map_it(z, it.a))
  var targets = filter_it(z, it.a == min_dist)
  targets.sort do (x, y: auto) -> int:
    result = cmp(x.b.y, y.b.y)
    if result == 0:
      result = cmp(x.b.x, y.b.x)
  let target = targets[0].b
  let target_dists = manhattan_distances(map, target)
  let candidate_squares = non_obstacle_cardinal_points(map, src)
  if candidate_squares.len == 0:
    return src
  let candidate_squares_z = zip(map_it(candidate_squares, target_dists[it.y][it.x]), candidate_squares)
  let candidate_squares_min_dist = min(map_it(candidate_squares_z, it.a))
  var candidate_squares_min = filter_it(candidate_squares_z, it.a == candidate_squares_min_dist)
  candidate_squares_min.sort do (x, y: auto) -> int:
    result = cmp(x.b.y, y.b.y)
    if result == 0:
      result = cmp(x.b.x, y.b.x)
  if candidate_squares_min[0].a == high(int):
    return src  # No reachable candidates
  let dst = candidate_squares_min[0].b

  map[dst.y][dst.x].npc = map[src.y][src.x].npc
  map[src.y][src.x].npc = nil

  return (dst.x, dst.y)


proc attack(map: Map, p: Point): Npc =
  let attacker = map[p.y][p.x].npc
  let kind = attacker.kind
  let cardinal_points = bounded_cardinal_points(map, p)
  let targets = filter_it(cardinal_points, map[it.y][it.x].kind == tkCavern and map[it.y][it.x].npc != nil and map[it.y][it.x].npc.kind != kind)
  if targets.len == 0:
    return
  let targets_with_hp = zip(map_it(targets, map[it.y][it.x].npc.hp), targets)
  let min_hp = min(map_it(targets_with_hp, it.a))
  var weak_targets = filter_it(targets_with_hp, it.a == min_hp)
  weak_targets.sort do (x, y: auto) -> int:
    result = cmp(x.b.y, y.b.y)
    if result == 0:
      result = cmp(x.b.x, y.b.x)
  let target_pos = weak_targets[0].b
  let target = map[target_pos.y][target_pos.x].npc
  target.hp -= attacker.attack
  if target.hp <= 0:
    result = map[target_pos.y][target_pos.x].npc
    map[target_pos.y][target_pos.x].npc = nil


proc remaining_hitpoints(): int =
  for y in 0..height-1:
    for x in 0..width-1:
      if map[y][x].kind == tkCavern and map[y][x].npc != nil:
        result += map[y][x].npc.hp


proc play(finish_on_dead_elf: bool): int =
  var
    rounds = 0
  while true:
    var moved = initSet[Point]()
    for y in 0..height-1:
      for x in 0..width-1:
        if map[y][x].kind == tkCavern and map[y][x].npc != nil and not ((x, y) in moved):
          proc has_enemy(p: Point): bool =
            if map[p.y][p.x].kind == tkWall:
              return false
            if map[p.y][p.x].npc == nil:
              return false
            if map[p.y][p.x].npc.kind != map[y][x].npc.kind:
              return true
            return false

          let npc = map[y][x].npc
          let cardinal_points = bounded_cardinal_points(map, (x, y))
          var pos: Point = (x, y)
          if not foldl(cardinal_points, a or has_enemy(b), false):
            var alive = 0
            for y in 0..height-1:
              for x in 0..width-1:
                if map[y][x].kind == tkCavern and map[y][x].npc != nil and map[y][x].npc.kind != npc.kind:
                  alive += 1
            if alive == 0:
              return rounds
            pos = move_npc(map, map[y][x].npc.kind, (x, y))
            moved.incl(pos)
          let dead = attack(map, pos)
          if finish_on_dead_elf and dead != nil and dead.kind == nkElf:
            return -1

    rounds += 1
    if not finish_on_dead_elf:
      echo("Round ", $rounds)
      echo(map)

init(3)
echo(map)
let end_round = play(false)
let hp_remaining = remaining_hitpoints()
echo(hp_remaining)
echo(end_round * hp_remaining)

var attack_points = 4
while true:
  echo(attack_points)
  init(attack_points)
  let end_round = play(true)
  if end_round == -1:
    attack_points += 1
    continue
  let hp_remaining = remaining_hitpoints()
  echo("  ", hp_remaining)
  echo("  ", end_round * hp_remaining)
  break