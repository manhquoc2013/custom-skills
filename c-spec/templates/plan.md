# PLAN.md template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

The execution plan. Written only after GO or a settled spec, one `REQ-` id per task. Read it to see every task, its requirement, its files, and the command that proves it. A task is the smallest unit that carries its own test cycle and is worth a fresh reviewer's gate: fold setup, configuration, and documentation into the task whose deliverable needs them, and split only where a reviewer could reject one task while approving its neighbour. Map the files before the tasks — that is where decomposition gets locked in.

```markdown
# PLAN

## Goal
<one sentence quoted from CONTEXT>

## Files
### <path>
<creates | modifies> — one line: what this file is responsible for

## Global constraints
<the spec's project-wide requirements — version floors, dependency limits, naming and copy rules, platform requirements — one line each, copied verbatim, or none>

## Review focus
<up to five input classes the spec implies but no task's test exercises, most likely first. The spec's silence on an input is not permission for that input to break the program. Pin each to the task that owns the code, as that task's test, or none>

## Progress
### Now
<the stage: planned, or wave N running>
### Done
<requirements already implemented and passed, one line each, or none>
### Open
<requirements not yet implemented, one line each, or none>
### Next
<the next wave to dispatch, or verify>

## Frozen
Requirements, Failure, Out of scope, and Kept, copied from CONTEXT as labeled lines

## Waves
### Wave 1
<one sentence: what this wave delivers>

#### T1
REQ: <REQ id>
Files: <one path per line>
Consumes: <a signature an earlier task produces, or none>
Produces: <the signature this task exports, or none>
Kept command: <command, or none>
Kept result: <that command's output before this work, or none>
Change: <one sentence: what this task does>
Steps:
1. <write the failing test>
2. <run it and watch it fail>
3. <the minimal change that makes it pass>
4. <run it and watch it pass>
Verify command: <command>
Verify result: <what a pass looks like>
```
