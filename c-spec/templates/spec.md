# SPEC.md template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

The settled spec. Publish it only after the user confirms the seams. Read it to see the agreed behavior, the seams that guard it, and what was ruled out. Seams: prefer one that already exists, take the highest one the code offers, and use as few as possible — one is ideal.

```markdown
## Problem statement
<the problem, in the user's words>

## Solution
<one paragraph: the shape of the answer>

## Progress
### Now
<the stage: drafting, seams under confirmation, or settled>
### Done
<what the user has already confirmed, one line each, or none>
### Open
<what is still unconfirmed, one line each, or none>
### Next
<the single next action>

## User stories
<A long numbered list, not one example: cover every aspect of the feature.>
### 1
As a <actor>, I want <feature>, so that <benefit>.

## Implementation decisions
<one decision per line. Decisions, not paths: no file paths, no code snippets — they go stale. Exception: a snippet that encodes a decision more precisely than prose can (a state shape, a schema, a reducer).>

## Testing decisions
<Test external behavior, never implementation details. Name the modules covered and the prior art for these tests in this repo.>
### <seam>
Catches: <what this seam would fail on>
Misses: <what it cannot see>

## Out of scope
<what this spec deliberately excludes, one item per line, or none>

## Seams
### <name>
Catches: <what this seam would fail on>
Misses: <what it cannot see>
```
