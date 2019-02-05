# See: https://github.com/asciinema/asciinema/blob/develop/doc/asciicast-v2.md
import json


type
  AsciinemaRecording* = ref object
    output: File
    buffer: string
    frame_delay: float32
    timestamp: float32
    next_frame_with_flush_file: bool


proc newAsciinemaRecording*(output: File, width, height: int, delay: float32,
                           timestamp: int = -1, command: string = "",
                           title: string = "",
                           next_frame_with_flush_file: bool = false): AsciinemaRecording =
  result = new AsciinemaRecording
  result.output = output
  result.frame_delay = delay
  result.next_frame_with_flush_file = next_frame_with_flush_file

  let header = %*
    {
      "version": 2,
      "width": width,
      "height": height,
      "env": {"TERM": "xterm-256color"}
    }
  if timestamp != -1:
    header["timestamp"] = %* timestamp
  if command != "":
    header["command"] = %* command
  if title != "":
    header["title"] = %* title


  output.write($header & "\n")


proc next_frame*(ar: AsciinemaRecording, delay: float32 = -1) =
  let frame = %*
    [
      ar.timestamp,
      "o",
      ar.buffer
    ]
  ar.output.write($frame & "\n")

  ar.buffer = ""
  if delay != -1:
    ar.timestamp += delay
  else:
    ar.timestamp += ar.frame_delay


proc write*(ar: AsciinemaRecording, str: string) =
  ar.buffer &= str


proc write*(ar: AsciinemaRecording, ch: char) =
  ar.buffer &= ch


proc write_frame*(ar: AsciinemaRecording, str: string, delay: float32 = -1) =
  ar.write(str)
  ar.next_frame(delay)


proc set_frame_delay*(ar: AsciinemaRecording, delay: float32) =
  ar.frame_delay = delay


proc set_fps*(ar: AsciinemaRecording, fps: float32) =
  ar.frame_delay = 1 / fps


proc flush_file*(ar: AsciinemaRecording) =
  discard


when isMainModule:
  import miniterminal
  import complex
  import sequtils
  import math


  let (width, height) = (80, 24)
  let ar = newAsciinemaRecording(stdout, width, height, 0.1, command="nim_asciinema_lib_demo")
  erase_screen(ar)
  for ch in "Hello World!":
    ar.write_frame($ch)
  for i in 1..24:
    ar.erase_screen()
    ar.set_cursor_pos(i, i)
    ar.write_frame("Hello World!")
  ar.erase_screen()
