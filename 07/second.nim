import algorithm
import hashes
import sequtils
import sets
import strutils
import tables

type
  Step = ref object of RootObj
    name: string
    duration: int
    effort: int
    dependencies: HashSet[Step]

proc newStep(name: string): Step =
  result = new Step
  result.name = name
  result.effort = 61 + (ord(name[0]) - ord('A'))
  result.duration = 61 + (ord(name[0]) - ord('A'))
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
    steps[step] = newStep(step)
  if not (dependency in steps):
    steps[dependency] = newStep(dependency)
  steps[step].dependencies.incl(steps[dependency])

const num_workers = 5
var tick = 0
var workers: seq[Step]
while true:
  let ready_for_work = num_workers - workers.len
  if ready_for_work > 0:
    var ready: seq[Step]
    for _, step in steps:
      if step in done or step in workers:
        continue
      if (step.dependencies - done).len == 0:
        ready.add(step)
    if ready.len == 0 and workers.len == 0:
      break
    ready.sort do (a, b: Step) -> int:
      result = cmp(a.name, b.name)
    for i in 0..min(ready_for_work, ready.len) - 1:
      workers.add(ready[i])
    workers.sort do (a, b: Step) -> int:
      result = cmp(a.duration, b.duration)
      if result == 0:
        result = cmp(a.name, b.name)
  let done_step = workers[0]
  workers.delete(0, 0)
  let duration = done_step.duration
  tick += duration
  done_ordered.add(done_step)
  done.incl(done_step)
  for current_step in workers:
    current_step.duration -= duration


echo("task order: ", join(done_ordered))
echo("duraction:  ", $tick)
