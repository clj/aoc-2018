import sequtils
import strformat
import sets

import "../19/both19.nim"


when isMainModule:
  ###
  # Part I
  ###
  var
    input = toSeq(stdin.lines)
    program = map(input[1..^1], parse_instruction19)
    ip_reg = parse_ip_pragma(input[0])

  print_program(program, ip_reg)

  run_template(run_once, 0, 0):
    if cpu.ip == 28:
      echo(cpu.registers)
      return false

  block:
    var cpu = new Cpu19
    cpu.ip_reg = ip_reg

    discard run_once(cpu, program)

  ###
  # Part II
  ###
  var
    values = initSet[int]()
    sequence: seq[int]
    last_size = 0

  run_template(run_find_repeat, 0, 0):
    if cpu.ip == 28:
      values.incl(cpu.registers[program[cpu.ip].a])
      if last_size == values.len:
        echo(sequence[sequence.high])
        return false
      else:
        last_size = values.len
      sequence.add(cpu.registers[program[cpu.ip].a])

  block:
    var cpu = new Cpu19
    cpu.ip_reg = ip_reg

    discard run_find_repeat(cpu, program)