import dom
import json
import math
import sequtils
import strformat
import strutils

import html5_canvas

type
  Terminal* = ref object
    columns, rows: int
    x*, y*: int
    cell_width, cell_height: int
    fg_colour, bg_colour: string
    font: string
    canvas: Canvas
    ctx: CanvasRenderingContext2D


proc clear*(term: Terminal) =
  term.ctx.save()
  term.ctx.fillStyle = term.bg_colour
  term.ctx.fillRect(0, 0, float(term.ctx.canvas.width), float(term.ctx.canvas.height))
  term.ctx.restore()


proc put_ch*(term: Terminal, ch: char, setup: bool = true) =
  if setup:
    term.ctx.save()
    term.ctx.textAlign = Left
    term.ctx.textBaseline = Top
    term.ctx.font = term.font
  term.ctx.fillStyle = term.bg_colour
  term.ctx.fillRect(float(term.cell_width * (term.x - 1)), float(term.cell_height * (term.y - 1)),
                    float(term.cell_width), float(term.cell_height))
  term.ctx.fillStyle = term.fg_colour
  term.ctx.fillText($ch, float(term.cell_width * (term.x - 1)), float(term.cell_height * (term.y - 1)))
  if setup:
    term.ctx.restore()
  term.x += 1
  if term.x > term.columns:
    term.x = 1
    term.y += 1

const
  escape = '\e'
  colours = ["0,0,0", "205,0,0", "0,205,0", "205,205,0", "0,0,238", "205,0,205", "0,205,205", "229,229,229"]


proc ansi_escape(term: Terminal, str: string, offset: var int) =
  assert str[offset] == escape
  assert str[offset + 1] == '['
  var parameters = @[""]
  offset += 2
  while true:
    let ch = str[offset]
    if ch in '0'..'9':
      parameters[parameters.high] &= ch
    elif ch == ';':
      parameters &= ""
    elif ch in 'A'..'~':
      break
    else:
      assert false, "argh!"
    offset += 1
  let op = str[offset]
  offset += 1
  case op
  of 'J':
    case parameters[0]
    of "2":
      term.clear()
    else:
      echo("Unimplemented: ", op, ' ', parameters)
  of 'H':
    term.x = 1
    term.y = 1
  of 'm':
    let attr = if parameters[0] == "": 0 else: parse_int(parameters[0])
    case attr:
    of 30..37:
      term.fg_colour = fmt"rgb({colours[attr-30]})"
    of 38:
      if parameters.len == 5 and parameters[1] == "2":
        term.fg_colour = fmt"rgb({parameters[2]},{parameters[3]},{parameters[4]})"
    of 40..47:
      term.bg_colour = fmt"rgb({colours[attr-40]})"
    of 48:
      if parameters.len == 5 and parameters[1] == "2":
        term.bg_colour = fmt"rgb({parameters[2]},{parameters[3]},{parameters[4]})"
    else:
      echo("Unimplemented: ", op, ' ', parameters)
  else:
    echo("Unimplemented: ", op, ' ', parameters)


proc write*(term: Terminal, str: string) =
  var i = 0
  while i <= str.high:
    let ch = str[i]
    if ch == '\r':
      term.x = 1
      i += 1
      continue
    elif ch == '\n':
      term.y += 1
      i += 1
      continue
    elif ch == escape:
      term.ansi_escape(str, i)
      continue
    term.ctx.save()
    term.ctx.fillStyle = term.bg_colour
    term.ctx.textAlign = Left
    term.ctx.textBaseline = Top
    term.ctx.fillStyle = term.fg_colour
    term.ctx.font = term.font
    term.put_ch(str[i], false)
    term.ctx.restore()
    i += 1


proc newTerminal*(canvas: Canvas, columns, rows: int): Terminal =
  result = new Terminal
  result.canvas = canvas
  result.ctx = canvas.getContext2D()
  result.columns = columns
  result.rows = rows
  result.x = 1
  result.y = 1
  result.cell_width = 10
  result.cell_height = 14
  result.bg_colour = "black"
  result.fg_colour = "white"
  result.font = "14px Monospace"
