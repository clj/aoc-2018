import sequtils
import strutils
import times
import strformat

type
  State[W: static[int]] = array[0..W,char]

const
  state_size = 100000

let input = to_seq(stdin.lines)
# initial state: #..#.#..##......###...###
let initial_state = "..." & input[0][15..^1] & "..."

var
  current_state: ptr State[state_size]
  new_state: ptr State[state_size]
  states: array[0..1, State[state_size]]
  # ...## => #
  rules = input[2..^1].filter_it(it.ends_with('#')).map_it(cstring it[0..^6])
  zero = 3
  upper_bound = initial_state.high
  lower_bound = 0

current_state = addr states[0]
new_state = addr states[1]

for i in 0..initial_state.high:
  current_state[i] = initial_state[i]


proc grow[T](it: T, print: bool) =
  new_state[0] = '.'
  new_state[1] = '.'
  new_state[2] = '.'
  var zero_add = 0
  for rule in rules:
    if equal_mem(addr current_state[lower_bound], rule, 5):
      new_state[3] = '#'
      zero_add = 1
      break
  for i in lower_bound+1..upper_bound-5:
    new_state[i + zero_add + 2] = '.'
    for rule in rules:
      if equal_mem(addr current_state[i], rule, 5):
        new_state[i + zero_add + 2] = '#'
        break
  new_state[upper_bound + zero_add - 2] = '.'
  var bounds_add = 0
  for rule in rules:
    if equal_mem(addr current_state[upper_bound-5], rule, 5):
      new_state[upper_bound + zero_add - 2] = '#'
      new_state[upper_bound + zero_add] = '.'
      bounds_add = 1
      break
  new_state[upper_bound + zero_add - 2] = '.'
  new_state[upper_bound + zero_add - 1] = '.'

  for i in 0..upper_bound:
    if new_state[i] == '#':
      if i < 3:
        lower_bound = 0
        break
      lower_bound = i - 3
      break

  zero += zero_add - lower_bound
  upper_bound += zero_add + bounds_add
  if print:
    echo(it, " ", new_state)
    echo(lower_bound)

  (current_state, new_state) = (new_state, current_state)


proc answer(): int =
  for i in 0..upper_bound:
    if current_state[i] == '#':
      result += i - zero

echo(0, " ", current_state)
for i in 1..20:
  grow(i, true)


echo("20: ", $answer())

for i in 0..initial_state.high:
  current_state[i] = initial_state[i]
current_state[initial_state.len] = char(0)
zero = 3
upper_bound = initial_state.high

echo(0, " ", current_state)
let start = cpu_time()
for i in 1..50000000000:
  grow(i, false)
  if i %% 10000 == 0:
    let duration = cpu_time() - start
    let rate = float(i)/duration
    var highest = 0
    for i in 1..upper_bound:
      if current_state[i] == '#':
        highest = i
    stdout.write(fmt("\r{i} {upper_bound} {highest} {rate}"))
    stdout.flush_file()


echo("50000000000: ", $answer())
