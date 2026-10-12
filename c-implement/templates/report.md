# agents/{id}.md template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

One implementer's report for one task. Read it to see what the implementer changed and what it proved. It carries evidence, never a verdict. This file is the full record; the message back to the parent is at most 15 lines.

`DONE_WITH_CONCERNS` is the honest middle: the task is finished and part of it is in doubt. Never report `DONE` on work you are unsure of, and never hide a doubt in `Concerns` to keep the status `DONE`.

```markdown
## Status
<DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT>

## Progress
### Now
<the task this report closes>
### Done
<what the implementer changed and ran, one line each, or none>
### Open
<what is unfinished or unproven, one line each, or none>
### Next
<the next action: hand to a verifier, or answer the block>

## RED
Command:
Output before the edit:

## GREEN
Command:
Output:

## Kept
Command:
Output:

## Files
<one path per line>

## Produces
<the signature this task exports, or none>

## Concerns
<what may be wrong or unproven, one line each, or none>
```
