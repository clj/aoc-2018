import pegs
import sequtils
import strformat
import tables
import times
import algorithm
import heapqueue
import math
import random

import "../lib/parsing.nim"
import "../lib/miniterminal.nim"


type
  Bound = tuple[minimum, maximum: int]
  Bounds = tuple[x, y, z: Bound]
  Point = tuple[x, y, z: int]
  Points = seq[Point]
  BotsLookup = Table[Point, int]
  Bot = tuple[point: Point, radius: int]
  Bots = seq[Bot]
  Candidate = tuple[point: Point, score, dist: int]

let
  bots = newTable[Point, int]()


template parse_bots(input: untyped, bots: untyped): untyped =
  block:
    # pos=<0,0,0>, r=4
    let parser = peg"""bot <- pos \s* ',' \s* radius
                       pos <- 'pos=<' digit ',' digit ',' digit '>'
                       radius <- 'r=' digit
                       digit <- \s*{ '-'? \d+ }\s*
                    """

    for line in input:
      if line =~ parser:
        bots[(x: parse_integer(matches[0]),
              y: parse_integer(matches[1]),
              z: parse_integer(matches[2]))] = parse_integer(matches[3])


proc largest[A, B](t: TableRef[A, B]): tuple[key: A, val: B] =
  assert t.len > 0
  let keys = toSeq(t.keys)
  var max_key = keys[0]
  for k in keys[1..^1]:
    if t[max_key] < t[k]: max_key = k
  result.key = max_key
  result.val = t[max_key]


proc manhattan_distance(a, b: Point): int {.inline.} =
  return abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z)


proc new_bounds(p: Point, r: int): Bounds =
  result.x.minimum = p.x - r
  result.x.maximum = p.x + r
  result.y.minimum = p.y - r
  result.y.maximum = p.y + r
  result.z.minimum = p.z - r
  result.z.maximum = p.z + r


parse_bots(stdin.lines(), bots)

###
# Part I
###

block:
  var
    strongest = bots.largest()
    in_range = 0

  for key, value in bots:
    if manhattan_distance(strongest.key, key) <= strongest.val:
      in_range += 1

  echo(fmt"Strongest bot: {strongest.key} with radius: {strongest.val}")
  echo(fmt"Bots in range of strongest bot: {in_range}")
  echo("\n")

###
# Part II
###

proc random_point(bounds: Bounds): Point =
  result.x = rand(bounds.x.minimum..bounds.x.maximum)
  result.y = rand(bounds.y.minimum..bounds.y.maximum)
  result.z = rand(bounds.z.minimum..bounds.z.maximum)


proc score(p: Point, bots: Bots): int =
  for bot in bots:
    if manhattan_distance(bot.point, p) <= bot.radius:
      result += 1


proc new_candidate(p: Point, bots: Bots): Candidate =
  result.point = p
  result.score = score(p, bots)
  result.dist = manhattan_distance(p, (0, 0, 0))


proc distances(point: Point, bots: Bots): (seq[int], int) =
  result[0] = newSeq[int](bots.len)
  for i in 0..bots.high:
    result[0][i] = manhattan_distance(bots[i].point, point) - bots[i].radius
    if result[0][i] < 0:
      result[0][i] = 0
      result[1] += 1


proc smaller(a, b: seq[int]): int =
  assert a.len == b.len
  for i in 0..a.high:
    if b[i] < a[i]:
      result += 1


proc step(p: Point, bots: Bots, radius: int): (Point, int) =
  const
    num_random_points = 100
    num_points = 3*3*3 + num_random_points
  var
    points: array[num_points, tuple[p: Point, score, smaller: int]]
    probs: array[num_points, float64]
    point: Point
    idx = 0

  let (center_distances, _) = distances(p, bots)
  for x in p.x - 1.. p.x + 1:
    for y in p.y - 1..p.y + 1:
      for z in p.z - 1..p.z + 1:
        if x == 0 and x == y and y == z:
          continue
        point = (x, y, z)
        let (distances, score) = distances(point, bots)
        let got_smaller = smaller(center_distances, distances)
        points[idx] = (point, score, got_smaller)
        idx += 1

  if radius > 1:
    let bounds = new_bounds(point, radius)
    for i in 0..num_random_points-1:
      point = random_point(bounds)
      let (distances, score) = distances(point, bots)
      let got_smaller = smaller(center_distances, distances)
      points[idx] = (point, score, got_smaller)
      idx += 1

  let current_num_points = idx

  var
    maximum = 0
    zeroes = 0
  for i in 0..current_num_points - 1:
    if points[i].smaller > maximum:
      maximum = points[i].smaller

  let t = rand(0..maximum)
  var candidate_idxs: array[num_points, int]
  idx = 0
  for i in 0..current_num_points - 1:
    if points[i].smaller >= t:
      candidate_idxs[idx] = i
      idx += 1

  let q = rand(0..idx - 1)
  point = points[candidate_idxs[q]].p
  return (point, sum(distances(point, bots)[0]))


var
  best: tuple[p: Point, s: int]

block:
  var
    bots_seq: Bots = toSeq(bots.pairs)
    i = 0
    steps_since_greater = 0
    p: Point = (0, 0, 0)
    radius = 100000
  best.s = high(int)
  while true:
    var s, d: int
    (p, s) = step(p, bots_seq, radius)

    steps_since_greater += 1
    if s < best.s:
        best = (p, s)
        steps_since_greater = 0
    elif radius > 10000 and steps_since_greater > 1000:
      radius -= 10000
      steps_since_greater = 0
    elif radius > 100 and radius <= 10000 and steps_since_greater > 100:
      radius -= 100
      steps_since_greater = 0
    elif radius > 1 and radius <= 100 and steps_since_greater > 100:
      radius -= 1
      steps_since_greater = 0
    elif steps_since_greater > 10000:
      break
    if i %% 10 == 0:
      stdout.write(fmt("current: {new_candidate(p, bots_seq)};\n"))
      stdout.write(fmt("sum(distance): {s}, search radius: {radius};\n"))
      stdout.write(fmt("best: {new_candidate(best.p, bots_seq)};"))
      cursor_up(stdout, 2)
      stdout.flush_file()

  cursor_down(stdout, 1)
  echo("\n")

block:
  var
    bots_seq: Bots = toSeq(bots.pairs)
    point = best.p
    bounds = point.new_bounds(50)
    best_candidate = new_candidate(point, bots_seq)

  for x in bounds.x.minimum..bounds.x.maximum:
    for y in bounds.y.minimum..bounds.y.maximum:
      for z in bounds.z.minimum..bounds.z.maximum:
        point = (x, y, z)
        let new_candidate = new_candidate(point, bots_seq)
        if new_candidate.score > best_candidate.score:
          best_candidate = new_candidate
        elif new_candidate.score == best_candidate.score and new_candidate.dist < best_candidate.dist:
          best_candidate = new_candidate

  echo(fmt("result: {best_candidate}"))
