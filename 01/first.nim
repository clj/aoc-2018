import parseutils

var freq = 0
for line in stdin.lines:
  var number: int
  discard line.parse_int(number)
  freq += number

echo(freq)
