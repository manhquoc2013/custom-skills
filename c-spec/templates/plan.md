# PLAN.md template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

The execution plan. Written only after GO or a settled spec, one `REQ-` id per task. Read it to see every task, its requirement, its files, and the command that proves it.

```markdown
# PLAN

## Goal
<one sentence quoted from CONTEXT>

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
Verify command: <command>
Verify result: <what a pass looks like>
```
