# A drop in replacement for terminal for the procs
# that just expect to be sending escape codes where
# the thing being written to does not have to be of
# type File, but can be anything with a write method

import strformat


proc eraseScreen*[T](f: T) =
  f.write("\e[H\e[2J")


proc hideCursor*[T](f: T) =
  f.write("\e[?25l")


proc showCursor*[T](f: T) =
  f.write("\e[?25h")


proc setCursorPos*[T](f: T, x, y: int) =
  let sx = if x == 1: "" else: $x
  let sy = if y == 1: "" else: $y
  f.write("\e[" & sy & ";" & sx & "H")


proc setCursorXPos*[T](f: T, x: int) =
  let s = if x == 1: "" else: $x
  f.write("\e[" & s & "G")


proc cursorUp*[T](f: T, n: int = 1) =
  let s = if n == 1: "" else: $n
  f.write("\e[" & s & "A")


proc cursorDown*[T](f: T, n: int = 1) =
  let s = if n == 1: "" else: $n
  f.write("\e[" & s & "B")


proc cursorForward*[T](f: T, n: int = 1) =
  let s = if n == 1: "" else: $n
  f.write("\e[" & s & "C")


proc cursorBackward*[T](f: T, n: int = 1) =
  let s = if n == 1: "" else: $n
  f.write("\e[" & s & "D")


type
  Style* = enum          ## different styles for text output
    styleBright = 1,     ## bright text
    styleDim,            ## dim text
    styleItalic,         ## italic (or reverse on terminals not supporting)
    styleUnderscore,     ## underscored text
    styleBlink,          ## blinking/bold text
    styleBlinkRapid,     ## rapid blinking/bold text (not widely supported)
    styleReverse,        ## reverse
    styleHidden,         ## hidden text
    styleStrikethrough   ## strikethrough

  ForegroundColor* = enum  ## terminal's foreground colors
    fgBlack = 30,          ## black
    fgRed,                 ## red
    fgGreen,               ## green
    fgYellow,              ## yellow
    fgBlue,                ## blue
    fgMagenta,             ## magenta
    fgCyan,                ## cyan
    fgWhite,               ## white
    fg8Bit,                ## 256-color (not supported, see ``enableTrueColors`` instead.)
    fgDefault              ## default terminal foreground color

  BackgroundColor* = enum  ## terminal's background colors
    bgBlack = 40,          ## black
    bgRed,                 ## red
    bgGreen,               ## green
    bgYellow,              ## yellow
    bgBlue,                ## blue
    bgMagenta,             ## magenta
    bgCyan,                ## cyan
    bgWhite,               ## white
    bg8Bit,                ## 256-color (not supported, see ``enableTrueColors`` instead.)
    bgDefault              ## default terminal background color


proc ansiStyleCode*(style: int): string =
  result = fmt("\e[{style}m")


template ansiStyleCode*(style: Style): string =
  ansiStyleCode(style.int)


# The styleCache can be skipped when `style` is known at compile-time
template ansiStyleCode*(style: static[Style]): string =
  (static(stylePrefix & $style.int & "m"))


proc setForegroundColor*[T](f: T, fg: ForegroundColor, bright=false) =
  var color = ord(fg)
  if bright:
    color = color + 60
  f.write(ansiStyleCode(color))


proc setBackgroundColor*[T](f: T, bg: BackgroundColor, bright=false) =
  var color = ord(bg)
  if bright:
    color = color + 60
  f.write(ansiStyleCode(color))


proc resizeTextArea*[T](f: T, w, h: int) =
  f.write("\e[8;" & $h & ";" & $w & "t")