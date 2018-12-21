import strutils

type
  Canvas* = ref object of RootObj
    canvas: string
    width, height: int
  CanvasSlice* = ref object of Canvas
    i: int


proc initCanvas*(width, height: int, bg: char = ' '): Canvas =
  let line = bg.repeat(width) & "\n"
  result = new Canvas
  result.canvas = line.repeat(height)
  result.width = width
  result.height = height


proc `[]`*(c: Canvas, i: int): CanvasSlice =
  result = new CanvasSlice
  shallowCopy(result.canvas, c.canvas)
  result.width = c.width
  result.height = c.height
  result.i = i


proc `[]=`*(c: CanvasSlice, j: int, v: char) =
  if j < 0 or c.i < 0 or j > c.height - 1 or c.i > c.width - 1:
    return
  c.canvas[j * c.width + c.i + j] = v


proc `$`*(c: Canvas): string {.inline.} =
  return c.canvas