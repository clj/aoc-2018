import strutils


var
  data = readAll(stdin).strip()
  min_length = data.len

for ch in 'a'..'z':
  var
    fixed_data = data
    processed = newStringOfCap(data.len)
    i = 0
    upper_ch = ch.toUpperAscii()

  while i < fixed_data.len:
    if data[i] == ch or data[i] == upper_ch:
      i += 1
    elif processed.len == 0:
      processed.add(fixed_data[0])
      i += 1
    elif i < fixed_data.len - 1 and fixed_data[i] != fixed_data[i+1] and fixed_data[i].toLowerAscii() == fixed_data[i+1].toLowerAscii():
      i += 2
    elif processed[processed.len - 1] != fixed_data[i] and processed[processed.len - 1].toLowerAscii() == fixed_data[i].toLowerAscii():
      processed.setLen(processed.len - 1)
      i += 1
    else:
      processed.add(fixed_data[i])
      i += 1
  if processed.len < min_length:
    min_length = processed.len


echo("Original length:     " & $data.len)
echo("Min Reacted length:  " & $min_length)