import algorithm
import hashes
import sequtils
import sets
import strutils
import tables

type
  Step = ref object of RootObj
    name: string
    dependencies: HashSet[Step]

proc newStep(): Step =
  result = new Step
  result.dependencies = initSet[Step]()

proc hash(x: Step): Hash =
  return x.name.hash()

proc `$`(x: Step): string =
  return x.name


var
  steps = initTable[string, Step]()
  done_ordered: seq[Step]
  done = initSet[Step]()


for line in stdin.lines:
  let parts = line.split()
  let (dependency, step) = (parts[1], parts[7])
  if not (step in steps):
    steps[step] = newStep()
    steps[step].name = step
  if not (dependency in steps):
    steps[dependency] = newStep()
    steps[dependency].name = dependency
  steps[step].dependencies.incl(steps[dependency])


while true:
  var ready: seq[Step]
  for _, step in steps:
    if step in done:
      continue
    if (step.dependencies - done).len == 0:
      ready.add(step)
  if ready.len == 0:
    break
  ready.sort do (a, b: Step) -> int:
    result = cmp(a.name, b.name)
  done_ordered.add(ready[0])
  done.incl(ready[0])


echo(join(done_ordered))