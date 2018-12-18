import sequtils
import strformat
import strutils

let input = "236021"
var
  scoreboard = @[3, 7]
  elves = @[0, 1]
  iterations = 0


proc iterate(): string =
  let new_recipe = scoreboard[elves[0]] + scoreboard[elves[1]]
  let first = new_recipe div 10
  let second = new_recipe %% 10
  if first != 0:
    scoreboard.add(first)
  scoreboard.add(second)
  elves[0] = (elves[0] + scoreboard[elves[0]] + 1) %% scoreboard.len
  elves[1] = (elves[1] + scoreboard[elves[1]] + 1) %% scoreboard.len

  if first != 0:
    return $first & $second
  return $second

proc print_scoreboard(scoreboard: seq[int]) =
  for i, score in scoreboard:
    if elves[0] == i:
      stdout.write(fmt("({score})"))
    elif elves[1] == i:
      stdout.write(fmt("[{score}]"))
    else:
      stdout.write(fmt(" {score} "))
  stdout.write("\n")


proc highlight_result(target: string) =
  stdout.write(" ".repeat((scoreboard.len-target.len) * 3 + 1))
  stdout.write("-".repeat(target.len * 3 - 2))
  stdout.write("\n")


proc create_recipes(target: string, print: bool): int64 =
  var scoreboard_end = scoreboard[max(0, scoreboard.len-target.len)..^1].join()
  while true:
    iterations += 1
    if iterations %% 10000 == 0:
      stdout.write(fmt("{iterations}\r"))
      stdout.flush_file()
    let new_recipes = iterate()
    if print:
      print_scoreboard(scoreboard)
    for i, recipe in new_recipes:
      scoreboard_end &= recipe
      scoreboard_end = scoreboard_end[max(0, scoreboard_end.len-target.len)..^1]
      if target == scoreboard_end:
        if print:
          highlight_result(target)
        if new_recipes.len == 2 and i == 0:
          return scoreboard.len - target.len - 1
        else:
          return scoreboard.len - target.len


print_scoreboard(scoreboard)
do_assert(create_recipes("01245", true) == 5)
do_assert(create_recipes("51589", true) == 9)
do_assert(create_recipes("92510", true) == 18)
do_assert(create_recipes("59414", false) == 2018)
stdout.write("...")
print_scoreboard(scoreboard[scoreboard.len-30..^1])
let result = create_recipes(input, false)
echo(fmt"{input}: {result} {scoreboard.len}")
stdout.write("...")
print_scoreboard(scoreboard[scoreboard.len-30..^1])
