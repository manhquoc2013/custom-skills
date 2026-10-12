# FLOW.md template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

The one state file for a feature. Rewrite it at the start and end of every gate. A resuming session reads this first: `Progress` says where the work stands, `Stop` says whether it may continue.

```markdown
# FLOW

## Goal
<one sentence: the outcome the user asked for, in their words>

## Slug
<slug>

## Progress
### Now
<one line: the gate or step running right now>
### Done
<what is already handled, one line each, or none>
### Open
<what is still unresolved, one line each, or none>
### Next
<the single next action, or none>

## Phase
<discuss | plan | execute | verify | ship | done>

## Wave
<wave id, or none>

## Task
<task id, or none>

## Base
<git SHA from `git rev-parse HEAD`, or none before the first edit>

## Attempt
<0-3>

## Last verdict
<NONE | PASS | REJECT>

## Stop
<none | needs-human | no-go | attempt-cap | done>

## Note
<what changed; when Stop is not none, the phase, the next action, and the files>
```
