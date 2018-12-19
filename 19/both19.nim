import pegs
import sequtils
import sets
import strformat
import tables

# This module can't be called the same as the one imported here,
# hence why this file is called both19.nim
import "../16/both.nim"
import "../lib/miniterminal.nim"


type
  Cpu19 = ref CpuObj19
  CpuObj19 = object of CpuObj
    ip: int
    ip_reg: 0..5
  Instruction19 = tuple[op: string, a, b, c: int]


proc parse_ip_pragma(instruction_text: string): int =
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
    result = (op: matches[0], a: inst[0], b: inst[1], c: inst[2])
  else:
    echo("error: " & instruction_text)
    quit(1)


proc `$`(regs: Registers): string =
  var first = true
  for i in 0..regs.high:
    result &= fmt"r{i}: {regs[i]:9d}"
    if i != regs.high:
       result &= " "


proc print_program(program: seq[Instruction19], ip_reg: int) =
  for i, instr in program:
    var a, b, c: string
    if instr.a == ip_reg:
      a = "  ip"
    else:
      a = fmt"  r{instr.a}"
    if instr.op[3] == 'r':
      if instr.b == ip_reg:
        b = "  ip"
      else:
        b = fmt"  r{instr.b}"
    else:
      b = fmt"{instr.b:4d}"
    if instr.c == ip_reg:
      c = "  ip"
    else:
      c = fmt"  r{instr.c}"
    if instr.op[0..2] in ["add", "mul", "ban", "bor"]:
      echo(fmt"{i:3d} {instr.op} {a} {b} {c}")
    elif instr.op[0..2] in ["set"]:
      if instr.op[3] == 'r':
        if instr.a == ip_reg:
          a = "  ip"
        else:
          a = fmt"  r{instr.a}"
      else:
        a = fmt"{instr.a:4d}"
      echo(fmt"{i:3d} {instr.op} {a}      {c}")
    elif instr.op[0..1] in ["gt", "eq"]:
      if instr.op[2] == 'r':
        if instr.a == ip_reg:
          a = "  ip"
        else:
          a = fmt"  r{instr.a}"
      else:
        a = fmt"{instr.a:4d}"
      echo(fmt"{i:3d} {instr.op} {a} {b} {c}")


var
  input = toSeq(stdin.lines)
  program = map(input[1..^1], parse_instruction19)
  ip_reg = parse_ip_pragma(input[0])


print_program(program, ip_reg)


proc run(cpu: var Cpu19, print_every: int = 0, cheat: bool = false) =
  var i: int
  var instruction: Instruction19
  var jumps = initSet[tuple[s: int, t: int]]()
  var last_jumps_print = 0
  while cpu.ip >= 0 and cpu.ip < program.len:
    instruction = program[cpu.ip]
    let fn = instruction_list[instruction.op]
    cpu.registers[cpu.ip_reg] = cpu.ip
    fn(cpu, instruction.a, instruction.b, instruction.c)
    if cheat and cpu.ip == 3 and cpu.registers[3] > cpu.registers[1]:
      cpu.ip = 12  # actual IP, we'll skip cpu.ip += 1
      continue
    if cpu.ip != cpu.registers[cpu.ip_reg]:
      jumps.incl((cpu.ip, cpu.registers[cpu.ip_reg] + 1))
    cpu.ip = cpu.registers[cpu.ip_reg]
    cpu.ip += 1
    if print_every > 0 and i %% print_every == 0:
      stdout.write(fmt("\ri: {i:12d} ip: {cpu.ip:4d} {instruction.op} r0..5: {cpu.registers}"))
      if last_jumps_print < jumps.len:
        stdout.write(fmt("\n{jumps}"))
        stdout.cursor_up()
        last_jumps_print = jumps.len
      stdout.flush_file()
    i += 1
  stdout.write(fmt("\ri: {i:12d} ip: {cpu.ip:4d} {instruction.op} r0..5: {cpu.registers}"))
  stdout.write(fmt("\n{jumps}"))
  stdout.write("\n")


block:
  var cpu = new Cpu19
  cpu.ip_reg = ip_reg
  run(cpu, 100)

block:
  var cpu = new Cpu19
  cpu.ip_reg = ip_reg
  cpu.registers[0] = 1
  run(cpu, 1000, true)