import parseutils


proc parse_integer*(s: string): int =
  if s.parse_int(result) == 0:
    echo("Error parsing as int: ", s)
    writeStackTrace()
    quit(1)