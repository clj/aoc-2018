import dom
import random
import sequtils
import strformat
import strutils

import html5_canvas

import common
import ../lib/miniterminal
import ../lib/html5_terminal


proc get_map(name: string): string =
  let maps = filter_it(dom.document.getElementsByTagName("script"),
                       it.getAttribute("type") == "text/x-game-map" and it.getAttribute("id") == name)
  return $maps[0].innerHtml


proc random_map(width, height: int): Map =
  result = newSeqWith(height, newSeq[char](width))
  for y in 0..result.high:
    for x in 0..result[0].high:
      result[y][x] = case rand(3)
                      of 0: '.'
                      of 1: '|'
                      else: '#'

dom.window.onload = proc(e: dom.Event) =
  var
    terminal_element = dom.document.getElementById("terminal")
    generation_counter = dom.document.getElementById("generation")
    input_select = OptionElement(dom.document.getElementById("input-select"))
    reset_button = dom.document.getElementById("reset-button")
    terminal = newTerminal(terminal_element.Canvas, 80, 25)
    timeout: ref Interval
    maps = newSeq[Map](2)
    i = 0

  # Set up the input dropdown
  for map in filter_it(dom.document.getElementsByTagName("script"), it.getAttribute("type") == "text/x-game-map"):
    var option = OptionElement(dom.document.createElement("option"))
    option.text = map.getAttribute("id")
    option.value = map.getAttribute("id")
    input_select.appendChild(option)
  var option = OptionElement(dom.document.createElement("option"))
  option.text = "random"
  option.value = "random"
  input_select.appendChild(option)

  proc reset() =
    let map_name = $input_select.options[input_select.selectedIndex].value

    if map_name != "random":
      let input = map_it(get_map(map_name).strip().split('\n'), it.strip())
      maps[0] = input_to_map(input)
    else:
      maps[0] = random_map(50, 50)
    maps[1] = newSeqWith(maps[0][0].len, newSeq[char](maps[0].len))

    terminal.eraseScreen()
    terminal.write($maps[0])

    i = 0
    generation_counter.innerHtml = "0"


  proc frame() =
    let done = not iterate(maps[i %% 2], maps[(i + 1) %% 2])

    terminal.eraseScreen()
    terminal.write($maps[i %% 2])
    i += 1
    generation_counter.innerHtml = $i

    if done:
      return

    timeout = dom.window.setTimeout(frame, 250)


  proc do_reset(e: Event) =
    dom.window.clearInterval(timeout)
    reset()
    timeout = dom.window.setTimeout(frame, 0)


  input_select.addEventListener("change", do_reset)
  reset_button.addEventListener("click", do_reset)

  reset()
  timeout = dom.window.setTimeout(frame, 0)
