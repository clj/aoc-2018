import pegs
import sequtils
import sets
import strformat
import tables
import times
import macros

# This module can't be called the same as the one imported here,
# hence why this file is called both19.nim
import "../16/both.nim"
import "../lib/miniterminal.nim"


type
  Cpu19* = ref CpuObj19
  CpuObj19* = object of CpuObj
    ip*: int
    ip_reg*: 0..5
    cycles: int
  Instruction19* = tuple[op_fn: InstructionFn, op_name: string, a, b, c: int]


proc parse_ip_pragma*(instruction_text: string): int =
  let parser = peg"'#ip' \s+ {\d+}"
  if instruction_text =~ parser:
    return parse_integer(matches[0])
  else:
    echo("error: " & instruction_text)
    quit(1)


proc parse_instruction19*(instruction_text: string): Instruction19 =
  let parser = peg"{\w+} \s+ {\d+} \s+ {\d+} \s+ {\d+}"
  if instruction_text =~ parser:
    let inst = map(matches[1..3], parse_integer)
    result = (op_fn: instruction_list[matches[0]], op_name: matches[0], a: inst[0], b: inst[1], c: inst[2])
  else:
    echo("error: " & instruction_text)
    quit(1)


proc `$`*(regs: Registers): string =
  var first = true
  for i in 0..regs.high:
    result &= fmt"r{i}: {regs[i]:9d}"
    if i != regs.high:
       result &= " "


proc print_program*(program: seq[Instruction19], ip_reg: int) =
  for i, instr in program:
    var a, b, c: string
    if instr.a == ip_reg:
      a = "      ip"
    else:
      a = fmt"      r{instr.a}"
    if instr.op_name[3] == 'r':
      if instr.b == ip_reg:
        b = "      ip"
      else:
        b = fmt"      r{instr.b}"
    else:
      b = fmt"{instr.b:8d}"
    if instr.c == ip_reg:
      c = "     ip"
    else:
      c = fmt"     r{instr.c}"
    if instr.op_name[0..2] in ["add", "mul", "ban", "bor"]:
      echo(fmt"{i:3d} {instr.op_name} {a} {b} {c}")
    elif instr.op_name[0..2] in ["set"]:
      if instr.op_name[3] == 'r':
        if instr.a == ip_reg:
          a = "     ip"
        else:
          a = fmt"      r{instr.a}"
      else:
        a = fmt"{instr.a:8d}"
      echo(fmt"{i:3d} {instr.op_name} {a}          {c}")
    elif instr.op_name[0..1] in ["gt", "eq"]:
      if instr.op_name[2] == 'r':
        if instr.a == ip_reg:
          a = "  ip"
        else:
          a = fmt"      r{instr.a}"
      else:
        a = fmt"{instr.a:8d}"
      echo(fmt"{i:3d} {instr.op_name} {a} {b} {c}")


template run_template*(name: untyped, print_every, limit: int, body: untyped): untyped =
  proc `name`(cpu: var Cpu19, program: openArray[Instruction19]): bool =
    var cpu {.inject.} = cpu
    var i {.inject.}: int
    when print_every > 0:
      var jumps = initSet[tuple[s: int, t: int]]()
      var last_jumps_print = 0
      let start = cpu_time()
    while cpu.ip >= 0 and cpu.ip < program.len:
      cpu.registers[cpu.ip_reg] = cpu.ip
      program[cpu.ip].op_fn(cpu, program[cpu.ip].a, program[cpu.ip].b, program[cpu.ip].c)
      `body`
      when print_every > 0:
        if cpu.ip != cpu.registers[cpu.ip_reg]:
          jumps.incl((cpu.ip, cpu.registers[cpu.ip_reg] + 1))
        if i %% print_every == 0:
          stdout.write(fmt("\ri: {i:12d} ip: {cpu.ip:4d} {program[cpu.ip].op_name} r0..5: {cpu.registers}"))
          if last_jumps_print < jumps.len:
            stdout.write(fmt("\n{jumps}"))
            stdout.cursor_up()
            last_jumps_print = jumps.len
          stdout.flush_file()
      cpu.ip = cpu.registers[cpu.ip_reg]
      cpu.ip += 1
      i += 1
      when limit > 0:
        if i >= limit:
          cpu.cycles = i
          return false
    when print_every > 0:
      let duration = cpu_time() - start
      stdout.write(fmt("\ri: {i:12d} ip: {cpu.ip:4d} ---- r0..5: {cpu.registers}"))
      stdout.write(fmt("\n{jumps}"))
      stdout.write(fmt("\ntime: {duration:.4f}; {int(float32(i)/(duration))}/s"))
      stdout.write("\n")
    cpu.cycles = i
    return true


run_template(run_print, 0, 0):
  discard


run_template(run_cheat, 0, 0):
  if cpu.ip == 3 and cpu.registers[3] > cpu.registers[1]:
    cpu.ip = 12  # actual IP, we'll skip cpu.ip += 1
    continue


template time_cpu*(body: untyped): untyped {.dirty.}=
  let start = cpu_time()
  body
  let duration = cpu_time() - start
  stdout.write(fmt("\ri: {cpu.cycles:12d} ip: {cpu.ip:4d} ---- r0..5: {cpu.registers}"))
  #stdout.write(fmt("\n{jumps}"))
  stdout.write(fmt("\ntime: {duration:8.4f}; {int(float32(cpu.cycles)/(duration))}/s"))
  stdout.write("\n")


when isMainModule:
  var
    input = toSeq(stdin.lines)
    program = map(input[1..^1], parse_instruction19)
    ip_reg = parse_ip_pragma(input[0])

  print_program(program, ip_reg)

  block:
    var cpu = new Cpu19
    cpu.ip_reg = ip_reg
    time_cpu:
      discard run_print(cpu, program)

  block:
    var cpu = new Cpu19
    cpu.ip_reg = ip_reg
    cpu.registers[0] = 1
    time_cpu:
      discard run_cheat(cpu, program)
