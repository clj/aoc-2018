import tables


var
  twice = 0
  thrice = 0

for line in stdin.lines:
  var
    counts = initCountTable[char]()
  for ch in line:
    counts[ch] = counts.getOrDefault(ch) + 1
  counts.sort()
  var
    line_twice = 0
    line_thrice = 0
  for ch, count in counts:
    if count == 1:
      break
    elif count == 2:
      line_twice = 1
    elif count == 3:
      line_thrice = 1
  twice += line_twice
  thrice += line_thrice

echo(twice * thrice)


