import pegs
import sequtils
import strutils
import algorithm
import strformat


type
  Group = object
    idx: int
    units: int
    hp: int
    attack_damage: int
    attack_type: string
    initiative: int
    weaknesses: seq[string]
    imunities: seq[string]
  Groups = seq[ref Group]
  Army = object
    name: string
    groups: Groups
  Armies = seq[ref Army]
  Game = object
    armies: Armies
  Attack = object
    army: ref Army
    enemy: ref Army
    attacker: ref Group
    target: ref Group
  Attacks = seq[Attack]
  TargetSelection = object
    army: ref Army
    attacker: ref Group
    target: ref Group
    damage: int
  TargetSelections = seq[TargetSelection]


proc parser(input: string): Game =
  let gameAst = peg"""
    game <- army (\n+ army)+
    army <- army_header \n groups
    army_header <- army_name ':'
    army_name <- (! ':' .)*
    groups <- (group \n)+
    group <- number_of_units spp hit_points spp (modifiers spp)? attack spp initiative
    number_of_units <- number sp 'units each'
    hit_points <- number sp 'hit points'
    modifiers <- '(' modifier ( sp ';' sp modifier )* ')'
    modifier <- modifier_type sp 'to' sp modifier_attack_type ( sp ',' sp modifier_attack_type )*
    modifier_type <- name
    modifier_attack_type <- name
    attack <- 'attack that does' sp number sp name sp 'damage'
    initiative <- 'initiative' sp number
    spp <- \s+ (('with an' / 'with' / 'at') \s+)?
    sp <- \s*
    number <- \d +
    name <- \w+
    """
  var
    game: Game
    name: string
    number: int
    current_modifier_type: string
    group_idx: int
  let
    gameParser = gameAst.eventParser():
      pkNonTerminal:
        enter:
          case p.nt.name
            of "army":
              game.armies.add(new Army)
              group_idx = 1
            of "group":
              game.armies[^1].groups.add(new Group)
              game.armies[^1].groups[^1].idx = group_idx
              group_idx += 1
        leave:
          if length == -1 and p.nt.name == "group":
            game.armies[^1].groups.delete(game.armies[^1].groups.high)
          if length > 0:
            let matchStr = s.substr(start, start+length-1)
            case p.nt.name
            of "army_name":
              game.armies[^1].name = matchStr
            of "number_of_units":
              game.armies[^1].groups[^1].units = number
            of "hit_points":
              game.armies[^1].groups[^1].hp = number
            of "attack":
              game.armies[^1].groups[^1].attack_damage = number
              game.armies[^1].groups[^1].attack_type = name
            of "initiative":
              game.armies[^1].groups[^1].initiative = number
            of "modifier_type":
              current_modifier_type = name
            of "modifier_attack_type":
              case current_modifier_type
              of "weak":
                game.armies[^1].groups[^1].weaknesses.add(name)
              of "immune":
                game.armies[^1].groups[^1].imunities.add(name)
            of "number":
              number = matchStr.parse_int()
            of "name":
              name = matchStr

  discard gameParser(input)
  return game


proc effective_power(group: ref Group, weak: bool = false): int =
  result = group.units * group.attack_damage
  if weak:
    result *= 2


proc effective_power(t: Attack, weak: bool = false): int =
  return effective_power(t.attacker, weak)


proc init_attackers(game: var Game): Attacks =
  for army_idx in 0..game.armies.high:
    let army = game.armies[army_idx]
    let enemy = game.armies[(army_idx + 1) %% game.armies.len]
    for group in army.groups:
      if group.units == 0:
        continue
      result.add(Attack())
      result[^1].army = army
      result[^1].enemy = enemy
      result[^1].attacker = group


proc sort(stuff: var Attacks) =
  stuff.sort do (a, b: Attack) -> int:
    result = cmp(effective_power(b), effective_power(a))
    if result == 0:
      result = cmp(b.attacker.initiative, a.attacker.initiative)


proc sort(t: var TargetSelections) =
  t.sort do (a, b: TargetSelection) -> int:
    result = cmp(b.damage, a.damage)
    if result == 0:
      result = cmp(b.target.effective_power(), a.target.effective_power())
      if result == 0:
        result = cmp(b.target.initiative, a.target.initiative)


proc sorted(t: TargetSelections): TargetSelections =
  return t.sorted do (a, b: TargetSelection) -> int:
    result = cmp(b.damage, a.damage)
    if result == 0:
      result = cmp(b.target.effective_power(), a.target.effective_power())
      if result == 0:
        result = cmp(b.target.initiative, a.target.initiative)


proc sorted(attacks: Attacks): Attacks =
  return attacks.sorted do (a, b: Attack) -> int:
    result = cmp(b.attacker.initiative, a.attacker.initiative)


proc target_selection(game: var Game, attacks: var Attacks): TargetSelections =
  var targeted: seq[ref Group]
  for attacker in attacks:
    if attacker.attacker.units == 0:
      continue
    var targets: TargetSelections
    for defending_group in attacker.enemy.groups:
      if defending_group.units == 0:
        continue
      if attacker.attacker.attack_type in defending_group.imunities:
        continue
      if defending_group in targeted:
        continue
      targets.add(TargetSelection())
      targets[^1].army = attacker.army
      targets[^1].attacker = attacker.attacker
      targets[^1].target = defending_group
      targets[^1].damage = effective_power(attacker.attacker, attacker.attacker.attack_type in defending_group.weaknesses)
    if targets.len > 0:
      let target = targets.sorted()[0].target
      targeted.add(target)
      for attack in attacks.mitems:
        if attack.attacker == attacker.attacker:
          attack.target = target
    result &= targets


proc attack(game: var Game, attacks: Attacks): string =
  let ordered_attacks = attacks.sorted()
  for attack in ordered_attacks:
    if attack.attacker.units == 0:
      continue
    if attack.target == nil:
      continue
    let damage = effective_power(attack.attacker, attack.attacker.attack_type in attack.target.weaknesses)
    let units_lost = min(attack.target.units, damage div attack.target.hp)
    result &= fmt("{attack.army.name} group {attack.attacker.idx} attacks defending group {attack.target.idx}, killing {units_lost} units\n")
    attack.target.units -= units_lost


proc finished(game: Game): bool =
  for army in game.armies:
    if foldl(army.groups, a + b.units, 0) == 0:
      return true
  return false


proc `$`(game: Game): string =
  for army in game.armies:
    result &= fmt("{army.name}:\n")
    for group in army.groups:
      result &= fmt("Group {group.idx} contains {group.units} units\n")


proc `$`(selections: TargetSelections): string =
  for selection in selections:
    result &= fmt("{selection.army.name} group {selection.attacker.idx} would deal defending group {selection.target.idx} {selection.damage} damage\n")


proc clone(game: Game): Game =
  deep_copy(result, game)


proc boost(game: Game, amount: int): Game =
  result = game.clone
  for group in result.armies[0].groups:
    group.attack_damage += amount



var
  input = stdin.read_all()
  game = parser(input)

block:
  var game = game.clone
  while not game.finished():
    echo("******************************")
    echo(game)

    var attacks = init_attackers(game)
    attacks.sort()

    var infection_system_target_selections = target_selection(game, attacks)
    echo(($infection_system_target_selections).strip())

    let attack_stats = attack(game, attacks)
    echo(attack_stats)

  echo(game)

  echo("Units left:")
  for army in game.armies:
    echo(fmt"  {army.name:20s} {foldl(army.groups, a + b.units, 0):6d}")
  echo("")

block:
  var
    boost = 0
  echo(fmt"boost     boostee   enemy")

  while true:
    boost += 1
    var
      game = game.boost(boost)
      last_combined_score = 0
    while not game.finished():
      var attacks = init_attackers(game)
      attacks.sort()

      discard target_selection(game, attacks)
      discard attack(game, attacks)
      var combined_score = foldl(game.armies[0].groups, a + b.units, 0)
      combined_score += foldl(game.armies[1].groups, a + b.units, 0)
      if last_combined_score == combined_score:
        break
      last_combined_score = combined_score

    let score = foldl(game.armies[0].groups, a + b.units, 0)
    let enemy_score = foldl(game.armies[1].groups, a + b.units, 0)

    echo(fmt"{boost:3d} {score:10d} {enemy_score:10d}")

    if enemy_score > 0:
      continue

    if score > 0:
      break