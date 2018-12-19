import macros
import parseutils
import pegs
import sequtils
import sets
import strformat
import strutils
import tables


type
  Registers* = array[0..5, int]
  Cpu* = ref CpuObj
  CpuObj* = object of RootObj
    registers*: Registers
    instruction_fns*: array[0..15, InstructionFn]
  InstructionFn* = proc(cpu: Cpu, a, b, c: int)
  Instruction* = tuple[op, a, b, c: int]
  Sample* = object
    before: Registers
    instruction: Instruction
    after: Registers
    hits: HashSet[string]


proc `$`*(a: Sample): string =
  result &= "Before: " & $a.before
  result &= "\n" & $a.instruction
  result &= "\nAfter: " & $a.after
  result &= "\nHits: " & $a.hits & "\n"


proc parse_integer*(s: string): int =
  if s.parse_int(result) == 0:
    echo("Error parsing as int: ", s)
    writeStackTrace()
    quit(1)


proc parse_sample*(sample: string): Sample =
  let parser = peg"""sample <- 'Before:' \s+ registers @\n instruction @\n 'After:' \s+ registers
                     registers <- '[' \s* {\d+} \s* ',' \s* {\d+} \s* ',' \s* {\d+} \s* ',' \s* {\d+} \s* ']'
                     instruction <- {\d+} \s+ {\d+} \s+ {\d+} \s+ {\d+}
                     """
  if sample =~ parser:
    let inst = map(matches[4..7], parse_integer)
    result.before[0..3] = map(matches[0..3], parse_integer)
    result.instruction = (op: inst[0], a: inst[1], b: inst[2], c: inst[3])
    result.after[0..3] = map(matches[8..11], parse_integer)
    result.hits = initSet[string]()
  else:
    echo(fmt"Parse error at: {sample}")
    quit(1)


proc parse_instruction*(instruction_text: string): Instruction =
  let parser = peg"{\d+} \s+ {\d+} \s+ {\d+} \s+ {\d+}"
  if instruction_text =~ parser:
    let inst = map(matches[0..3], parse_integer)
    result = (op: inst[0], a: inst[1], b: inst[2], c: inst[3])
  else:
    echo("error: " & instruction_text)
    quit(1)

template imm(statement: typed): untyped =
  statement


template reg(statement: typed): untyped =
  cpu.registers[statement]

var instruction_list* = initTable[string, InstructionFn]()


macro getNameAsString(thing: typed): untyped =
  result = nnkStmtList.newTree()
  result.add(newLit(thing.strVal()[4..^1]))

template instruction(name, body: untyped): untyped =
  proc `inst name`*(cpu: Cpu, a, b, c: int) =
    var cpu {.inject.} = cpu
    let a {.inject.} = a
    let b {.inject.} = b
    let c {.inject.} = c
    body
  instruction_list[getNameAsString(`inst name`)] = `inst name`


instruction(addr):
  reg(c) = reg(a) + reg(b)


instruction(addi):
  reg(c) = reg(a) + imm(b)


instruction(mulr):
  reg(c) = reg(a) * reg(b)


instruction(muli):
  reg(c) = reg(a) * imm(b)


instruction(banr):
  reg(c) = reg(a) and reg(b)


instruction(bani):
  reg(c) = reg(a) and imm(b)


instruction(borr):
  reg(c) = reg(a) or reg(b)


instruction(bori):
  reg(c) = reg(a) or imm(b)


instruction(setr):
  reg(c) = reg(a)


instruction(seti):
  reg(c) = imm(a)


instruction(gtir):
  if imm(a) > reg(b):
    reg(c) = 1
  else:
    reg(c) = 0


instruction(gtri):
  if reg(a) > imm(b):
    reg(c) = 1
  else:
    reg(c) = 0


instruction(gtrr):
  if reg(a) > reg(b):
    reg(c) = 1
  else:
    reg(c) = 0


instruction(eqir):
  if imm(a) == reg(b):
    reg(c) = 1
  else:
    reg(c) = 0


instruction(eqri):
  if reg(a) == imm(b):
    reg(c) = 1
  else:
    reg(c) = 0


instruction(eqrr):
  if reg(a) == reg(b):
    reg(c) = 1
  else:
    reg(c) = 0


proc test_instructions(sample: var Sample) =
  for instr_name, instr_fn in instruction_list:
    var cpu = new Cpu
    cpu.registers = sample.before
    try:
      instr_fn(cpu, sample.instruction.a, sample.instruction.b, sample.instruction.c)
    except:
      echo(fmt"Error: {instr_name}")
      continue
    if cpu.registers == sample.after:
      sample.hits.incl(instr_name)
      discard


when isMainModule:
  let
    input = stdin.read_all()
    instruction_samples_text = input.split("\n\n\n")[0].split("\n\n")
    test_program_text = input.split("\n\n\n")[1].strip().split("\n")
    test_program = map(test_program_text, parse_instruction)

  var
    instruction_samples = map(instruction_samples_text, parse_sample)

  let example = """
Before: [3, 2, 1, 1]
9 2 1 2
After:  [3, 2, 2, 1]
""".strip()
  var example_instruction_samples = parse_sample(example)
  test_instructions(example_instruction_samples)
  echo("Example:")
  echo(fmt"  Instructions matching sample {example_instruction_samples.hits}")

  for sample in instruction_samples.mitems:
    test_instructions(sample)

  echo(fmt("\nNumber of samples matching 3+ instructions: {filter_it(instruction_samples, it.hits.len >= 3).len}"))

  proc done(samples: openArray[Sample]): bool =
    return all_it(instruction_samples, it.hits.len == 0)

  var cpu = new Cpu
  while not done(instruction_samples):
    let one_instruction_samples = filter_it(instruction_samples, it.hits.len == 1)
    let instr_name = toSeq(one_instruction_samples[0].hits.items())[0]
    let instr = instruction_list[instr_name]
    cpu.instruction_fns[one_instruction_samples[0].instruction.op] = instr
    for sample in instruction_samples.mitems:
      sample.hits.excl(instr_name)


  for instruction in test_program:
    let fn = cpu.instruction_fns[instruction.op]
    fn(cpu, instruction.a, instruction.b, instruction.c)

  let instr_fns_to_name = newTable[InstructionFn, string]()
  for key, value in instruction_list:
    instr_fns_to_name[value] = key

  echo("\nInstruction assignments:")
  for i, inst in cpu.instruction_fns:
    echo(fmt"  cpu.instruction_fns[{i}] = inst{instr_fns_to_name[inst]}")

  echo(fmt("\nr0: {cpu.registers[0]}"))