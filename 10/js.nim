import dom
import json
import math
import sequtils
import strformat

import html5_canvas

import common

# Useful resources:
#   https://developer.mozilla.org/en-US/docs/Web/API/Window/requestAnimationFrame
#   http://www.javascriptkit.com/javatutors/requestanimationframe.shtml
#   https://videlais.com/2014/03/16/the-many-and-varied-problems-with-measuring-font-height-for-html5-canvas/
#   https://16bpp.net/blog/post/html5-canvas-bindings-for-nims-javascript-target


const
  text_height = 30.0
  half_text_height = text_height / 2.0


proc json_to_points[T](json: JsonNode): Points[T] =
  for p in json.get_elems():
    when T is int:
      let d = map_it(p.get_elems(), it.get_int())
    elif T is float:
      let d = map_it(p.get_elems(), it.get_float())
    else: {.fatal: fmt"Type {T} not supported for json_to_points".}
    result.add((d[0], d[1], d[2], d[3]))


proc draw_scale_axis(ctx: CanvasRenderingContext2D, length: float, value: string) =
  ctx.save()
  ctx.fillStyle = "white"
  ctx.strokeStyle = "white"
  ctx.textAlign = Center
  ctx.textBaseline = Middle
  ctx.beginPath()
  ctx.moveTo(text_height, half_text_height)
  ctx.lineTo(length - text_height, half_text_height)
  ctx.moveTo(text_height + 10, 10)
  ctx.lineTo(text_height, half_text_height)
  ctx.lineTo(text_height + 10, 20)
  ctx.moveTo(length - text_height - 10, 10)
  ctx.lineTo(length - text_height, half_text_height)
  ctx.lineTo(length - text_height - 10, 20)
  ctx.stroke()
  let text_h_metrics = ctx.measureText(value)
  ctx.fillStyle = "#0f0f23"
  ctx.fillRect(length/2 - text_h_metrics.width/2 - 10, 0, text_h_metrics.width + 20, 29)
  ctx.fillStyle = "white"
  ctx.fillText(value, length/2, 15)
  ctx.restore()


proc draw[T](points: Points[T], bounds: Bounds[T], ctx: CanvasRenderingContext2D) =
  let
    canvas_width = float(ctx.canvas.width)
    canvas_height = float(ctx.canvas.height)
    width = bounds.maxx - bounds.minx
    height = bounds.maxy - bounds.miny
    scale_x = (canvas_width - (text_height * 2)) / float(width + 1)
    scale_y = (canvas_height - (text_height * 2)) / float(height + 1)

  ctx.save()
  ctx.fillStyle = "white"

  ctx.draw_scale_axis(canvas_width, $int(width))
  ctx.translate(0, canvas_height)
  ctx.rotate(-PI / 2)
  ctx.draw_scale_axis(canvas_height, $int(height))
  ctx.setTransform(1, 0, 0, 1, 0, 0)

  ctx.translate(text_height, text_height)
  ctx.scale(scale_x, scale_y)
  ctx.translate(-float(bounds.minx), -float(bounds.miny))
  for point in points:
    ctx.fillRect(float(point.x), float(point.y), 1, 1)
  ctx.restore()


proc clear(ctx: CanvasRenderingContext2D) =
  ctx.save()
  ctx.fillStyle = "#0f0f23"
  ctx.fillRect(0, 0, float(ctx.canvas.width), float(ctx.canvas.height))
  ctx.restore()


proc frame[T](points: Points[T], bounds: Bounds[T], ctx: CanvasRenderingContext2D) =
  ctx.clear()
  points.draw(bounds, ctx)


proc calc_fps[T](bounds: Bounds[T]): float =
  let height = bounds.maxy - bounds.miny
  result = height / 10


proc quit[T](old_bounds, new_bounds: Bounds[T]): bool =
    let last_height = old_bounds.maxy - old_bounds.miny
    let height = new_bounds.maxy - new_bounds.miny
    let last_width = old_bounds.maxx - old_bounds.minx
    let width = new_bounds.maxx - new_bounds.minx
    return last_width < width or last_height < height


proc canvas_on_click(e: Event)  # forward decl


proc loop[T](points: var Points[T], canvas: Canvas) =
  let ctx = canvas.getContext2D()
  var
    bounds = points.bounds()
    fps = calc_fps(bounds)

  ctx.font = "14px Monospace"

  proc run(timestamp: float) =
    points.frame(bounds, ctx)
    if fps >= 60:
      bounds = points.move_sky(ratio=fps/60)
    else:
      let new_bounds = points.move_sky(ratio=1/(60-fps))
      if quit(bounds, new_bounds):
        canvas.addEventListener("click", canvas_on_click)
        return
      bounds = new_bounds
    fps = calc_fps(bounds)

    discard dom.window.requestAnimationFrame(run)

  discard dom.window.requestAnimationFrame(run)


proc canvas_on_click(e: Event) =
  let
    element = e.target
    data_id = element.getAttribute("data-data-id")
    data = parseJson($(dom.document.getElementById(data_id).innerHtml))
  element.removeEventListener("click", canvas_on_click)
  var points = json_to_points[float](data)  # json.to doesn't work...
  loop(points, element.Canvas)


dom.window.onload = proc(e: dom.Event) =
  let elements = dom.document.getElementsByClassName("day10-canvas")

  for i, _ in elements:
    elements[i].addEventListener("click", canvas_on_click)
