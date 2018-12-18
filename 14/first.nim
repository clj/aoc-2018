import sequtils
import strformat
import strutils

let input = 236021
var
  scoreboard = @[3, 7]
  elves = @[0, 1]
  recipes = 0


proc iterate() =
  let new_recipe = scoreboard[elves[0]] + scoreboard[elves[1]]
  let first = new_recipe div 10
  let second = new_recipe %% 10
  if first != 0:
    scoreboard.add(first)
    recipes += 1
  scoreboard.add(second)
  recipes += 1
  elves[0] = (elves[0] + scoreboard[elves[0]] + 1) %% scoreboard.len
  elves[1] = (elves[1] + scoreboard[elves[1]] + 1) %% scoreboard.len


proc print_scoreboard() =
  for i, score in scoreboard:
    if elves[0] == i:
      stdout.write(fmt("({score})"))
    elif elves[1] == i:
      stdout.write(fmt("[{score}]"))
    else:
      stdout.write(fmt(" {score} "))
  stdout.write("\n")


proc highlight_result(target: int) =
  stdout.write(" ".repeat(target * 3 + 1))
  stdout.write("-".repeat(10 * 3 - 2))
  stdout.write("\n")


proc get_result(target: int): auto =
  return map_it(scoreboard[target..target+10-1], $it).join()


proc create_recipes(target: int, print: bool): string =
  while recipes < target + 10 - 1:
    if print:
      print_scoreboard()
    iterate()

  if print:
    print_scoreboard()
    highlight_result(target)
  return get_result(target)


do_assert(create_recipes(5, true) == "0124515891")
do_assert(create_recipes(9, true) == "5158916779")
do_assert(create_recipes(18, true) == "9251071085")
do_assert(create_recipes(2018, false) == "5941429882")
echo(fmt"{input}: {create_recipes(input, false)}")