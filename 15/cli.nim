import sequtils

import common

proc play(area: var Area, finish_on_dead_elf: bool): int =
  var
    rounds = 0
  while true:
    if round(area, finish_on_dead_elf):
      if area.elves == 0 or area.goblins == 0:
        return rounds
      return -1

    rounds += 1
    if not finish_on_dead_elf:
      echo("Round ", $rounds)
      let hp_remaining = area.map.remaining_hitpoints()
      echo("HP: ", hp_remaining)
      echo(area.map)


let
  input = to_seq(stdin.lines)


var
  area: Area


area.init(input, 3)
echo(area.map)
let end_round = area.play(false)
let hp_remaining = area.map.remaining_hitpoints()
echo(hp_remaining)
echo(end_round * hp_remaining)

var attack_points = 4
while true:
  echo(attack_points)
  area.init(input, attack_points)
  let end_round = area.play(true)
  if end_round == -1:
    attack_points += 1
    continue
  let hp_remaining = area.map.remaining_hitpoints()
  echo("  ", hp_remaining)
  echo("  ", end_round * hp_remaining)
  break