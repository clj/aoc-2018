import sequtils
import strutils
import times
import strformat

const
  small_gen_count = 20
  large_gen_count = 50000000000

let input = to_seq(stdin.lines)
# initial state: #..#.#..##......###...###
let initial_state = "..." & input[0][15..^1] & "..."

var
  current_state = initial_state
  new_state = initial_state
  # ...## => #
  rules = input[2..^1].filter_it(it.ends_with('#')).map_it(it[0..^6])
  zero = 3'i64
  last_zero = 3'i64

proc grow[T](i: T, print: bool) =
  current_state = new_state
  last_zero = zero

  new_state = ""
  for i in 0..current_state.len-5:
    var plant = '.'
    for rule in rules:
      if current_state[i..i+4] == rule:
        plant = '#'
        break
    new_state &= plant
  if new_state[0] == '#':
    zero += 1
    new_state = "..." & new_state
  else:
    new_state = ".." & new_state
  let hash_idx = new_state.find('#')
  if hash_idx > 3:
    zero -= hash_idx - 3
    new_state = new_state[hash_idx - 3..^1]
  if new_state[new_state.high] == '#':
    new_state = new_state & "..."
  else:
    new_state = new_state & ".."

  if print:
    echo(fmt("{i}: {zero} {new_state}"))


proc answer(): int64 =
  for i in 0..new_state.high:
    if new_state[i] == '#':
      result += i - zero

echo(0, " ", current_state)
for i in 1..small_gen_count:
  grow(i, true)

echo(fmt("{small_gen_count}: {answer()}"))

current_state = initial_state
new_state = initial_state
zero = 3

echo(0, " ", current_state)
for i in 1..large_gen_count:
  grow(i, true)
  if i > 1 and current_state == new_state:
    echo(i, " ", new_state)
    zero += (zero - last_zero) * (large_gen_count - i)
    echo(fmt("{large_gen_count} ({zero}): {answer()}"))

    break