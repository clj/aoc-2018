# A drop in replacement for terminal for the procs
# that just expect to be sending escape codes where
# the thing being written to does not have to be of
# type File, but can be anything with a write method

proc eraseScreen*[T](f: T) =
  f.write("\e[H\e[2J")

proc setCursorPos*[T](f: T, x, y: int) =
  f.write("\e[" & $x & ";" & $y & "H")

proc cursorDown*[T](f: T, n: int = 1) =
  f.write("\e[" & $n & "E")

proc cursorUp*[T](f: T, n: int = 1) =
  f.write("\e[" & $n & "F")
