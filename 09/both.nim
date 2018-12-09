import lists
import parseutils
import sequtils
import strutils


type
  marble = ref DoublyLinkedNodeObj[int]


let input = to_seq(stdin.lines)[0].split()
var
  num_players: int
  last_marble: int


if input[0].parse_int(num_players) == 0 or input[6].parse_int(last_marble) == 0:
  echo("Error parsing ", input[0], " or ", input[6])
  quit(1)


var
  circle = initDoublyLinkedRing[int]()
  zero: marble
  current_marble = 0
  current_player = 0
  players = newSeq[DoublyLinkedList[int]](num_players)


proc place_marble(): seq[marble] =
  current_player = ((current_player + 1) %% (num_players + 1))
  if current_player == 0:
    current_player = 1
  if current_marble %% 23 == 0:
    let current = newDoublyLinkedNode(current_marble)
    let remove = circle.head.prev.prev.prev.prev.prev.prev.prev # :)
    circle.head = remove.next
    circle.remove(remove)
    result = @[current, remove]
  else:
    let new_marble = newDoublyLinkedNode(current_marble)
    circle.head = circle.head.next.next
    circle.append(new_marble)
    circle.head = new_marble
  current_marble += 1


proc print_marble(m: marble) =
  if m == circle.head:
    stdout.write("(")
  stdout.write($m.value)
  if m == circle.head:
    stdout.write(")")


proc print_game_state() =
  var
    current = zero

  if current_player == 0:
    stdout.write("[-] ")
  else:
    stdout.write("[", $current_player, "] ")

  print_marble(current)
  current = zero.next
  while current != zero:
    stdout.write(" ")
    print_marble(current)
    current = current.next
  stdout.write("\n")


proc play(start_marble, end_marble: int) =
  for i in start_marble..end_marble:
    #print_game_state()
    let keeps = place_marble()
    if keeps.len != 0:
      for m in keeps:
        players[current_player - 1].append(m)


proc calc_score(marbles: DoublyLinkedList[int]): int =
  for marble_value in marbles:
    result += marble_value


proc max_score():int =
  for player in players:
    result = max(result, calc_score(player))


for i, _ in players:
  players[i] = initDoublyLinkedList[int]()

zero = newDoublyLinkedNode(0)
circle.append(zero)
current_marble = 1

play(1, last_marble)

#print_game_state()

echo($max_score())

play(last_marble, last_marble * 100)

#print_game_state()

echo($max_score())
