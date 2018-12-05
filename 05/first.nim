import strutils


var
  data = readAll(stdin).strip()
  processed = newStringOfCap(data.len)
  i = 0

while i < data.len:
  if processed.len == 0:
    processed.add(data[0])
    i += 1
  elif i < data.len - 1 and data[i] != data[i+1] and data[i].toLowerAscii() == data[i+1].toLowerAscii():
    i += 2
  elif processed[processed.len - 1] != data[i] and processed[processed.len - 1].toLowerAscii() == data[i].toLowerAscii():
    processed.setLen(processed.len - 1)
    i += 1
  else:
    processed.add(data[i])
    i += 1

echo("Original length: " & $data.len)
echo("Reacted length:  " & $processed.len)