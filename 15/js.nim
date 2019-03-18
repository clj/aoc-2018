import dom
import sequtils
import strutils

import html5_canvas

import common
import ../lib/miniterminal
import ../lib/html5_terminal


proc get_map(name: string): string =
  let maps = filter_it(document.getElementsByTagName("script"),
                       it.getAttribute("type") == "text/x-game-map" and it.getAttribute("id") == name)
  return $maps[0].innerHtml


dom.window.onload = proc(e: dom.Event) =
  var
    area: Area
    i = 0
    input_select = OptionElement(dom.document.getElementById("input-select"))
    attack_slider = dom.document.getElementById("attack-slider")
    attack_slider_value = dom.document.getElementById("attack-slider-value")
    step_button = dom.document.getElementById("step-button")
    run_button = dom.document.getElementById("run-button")
    reset_button = dom.document.getElementById("reset-button")
    terminal_element = dom.document.getElementById("terminal")
    terminal = newTerminal(terminal_element.Canvas, 80, 25)
    timeout: ref Interval
  terminal.clear()


  proc render() =
    terminal.eraseScreen()
    terminal.write(area.map.output())
    terminal.write("\r\n\n")
    terminal.write("Iteration: " & $i & "\r\n")
    terminal.write("Elves:     " & $area.elves & "\r\n")
    terminal.write("Goblins:   " & $area.goblins & "\r\n")
    let hp_remaining = area.map.remaining_hitpoints()
    terminal.write("Total HP:  " & $hp_remaining & "\r\n")


  proc initialise(name: string, attack: int) =
    let
      input = map_it(get_map(name).strip().split('\n'), it.strip())

    terminal.clear()
    area.init(input, attack)
    i = 0
    render()


  proc step(): bool =
    i += 1

    let done = area.round(false)
    render()
    if done:
      return true

    return false


  proc do_step(e: Event) =
    step_button.disabled = true
    input_select.disabled = true
    attack_slider.disabled = true
    proc fn =
      discard step()
      step_button.disabled = false
    discard dom.window.setTimeout(fn, 0)


  proc do_run(e: Event)


  proc do_pause(e: Event) =
    run_button.removeEventListener("click", do_pause)
    run_button.addEventListener("click", do_run)
    step_button.disabled = false
    run_button.innerHtml = "<i class='fas fa-running'>"
    dom.window.clearInterval(timeout)


  proc do_run(e: Event) =
    step_button.disabled = true
    input_select.disabled = true
    attack_slider.disabled = true
    run_button.innerHtml = "<i class='fas fa-pause'>"
    run_button.removeEventListener("click", do_run)
    run_button.addEventListener("click", do_pause)

    proc fn() =
      if step():
        step_button.disabled = true
        run_button.disabled = true
        input_select.disabled = true
        return

      timeout = dom.window.setTimeout(fn, 500)

    discard dom.window.setTimeout(fn, 0)


  proc do_reset(e: Event) =
    run_button.removeEventListener("click", do_pause)
    run_button.removeEventListener("click", do_run)
    run_button.addEventListener("click", do_run)
    step_button.disabled = false
    run_button.disabled = false
    input_select.disabled = false
    attack_slider.disabled = false
    run_button.innerHtml = "<i class='fas fa-running'>"
    dom.window.clearInterval(timeout)
    initialise($input_select.options[input_select.selectedIndex].value, parse_int($attack_slider.value))


  proc do_slider_change(e: Event) =
    attack_slider_value.innerHtml = attack_slider.value
    do_reset(e)


  proc do_slider_update(e: Event) =
    attack_slider_value.innerHtml = attack_slider.value


  proc do_slider_key(e: Event) =
    attack_slider.value = $(parse_int($attack_slider.value) + 1)
    attack_slider_value.innerHtml = attack_slider.value


  # Set up the input dropdown
  let maps = filter_it(document.getElementsByTagName("script"), it.getAttribute("type") == "text/x-game-map")
  for map in maps:
    var option = OptionElement(dom.document.createElement("option"))
    option.text = map.getAttribute("id")
    option.value = map.getAttribute("id")
    input_select.appendChild(option)

  # Set up the buttons and dropdown
  step_button.addEventListener("click", do_step)
  run_button.addEventListener("click", do_run)
  reset_button.addEventListener("click", do_reset)
  input_select.addEventListener("change", do_reset)
  attack_slider.addEventListener("change", do_slider_change)
  attack_slider.addEventListener("input", do_slider_update)
  attack_slider.addEventListener("keydown", do_slider_key)  # XXX: No focus???

  initialise("input", 3)
