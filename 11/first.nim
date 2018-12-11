const
  width = 300
  height = 300
  window = 3

type
  Grid[W, H: static[int]] =
    array[1..W, array[1..H, int]]


proc power_level(x, y, serial_number: int): int =
    # Find the fuel cell's rack ID, which is its X coordinate plus 10.
    let rack_id = x + 10
    # Begin with a power level of the rack ID times the Y coordinate.
    var power_level = rack_id * y
    # Increase the power level by the value of the grid serial number (your puzzle input).
    power_level += serial_number
    # Set the power level to itself multiplied by the rack ID.
    power_level *= rack_id
    # Keep only the hundreds digit of the power level (so 12345 becomes 3; numbers with no hundreds digit become 0).
    power_level = (power_level div 100) %% 10
    # Subtract 5 from the power level.
    power_level -= 5
    return power_level

doAssert(power_level(3, 5, 8) == 4)
doAssert(power_level(122,79, 57) == -5)
doAssert(power_level(217,196, 39) == 0)
doAssert(power_level(101,153, 71) == 4)

proc find_window(serial_number: int): tuple[p: int, x: int, y: int] =
  var
    grid: Grid[width, height]

  for x in 1..width:
    for y in 1..height:
      grid[x][y] = power_level(x, y, serial_number)

  var
    max_power = low(int)
    (max_x, max_y) = (-1, -1)

  for x in 1..width - window:
    for y in 1..height - window:
      var power = 0
      for ox in x..x+window - 1:
        for oy in y..y+window - 1:
          power += grid[ox][oy]
      if power > max_power:
        max_power = power
        max_x = x
        max_y = y

  return (max_power, max_x, max_y)

doAssert(find_window(18) == (29, 33, 45))
doAssert(find_window(42) == (30, 21, 61))
let result = find_window(7315)
echo($result)
echo($result.x, ',', $result.y)

