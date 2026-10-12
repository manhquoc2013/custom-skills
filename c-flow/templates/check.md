# checks/{row}.md template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

The logic check for one row. That row's verifier writes it; the implementer never does. A row that carries several tasks gets one `## Evidence` block per `REQ-`. Read it to see what was exercised, what passed, and what it breaks.

```markdown
## Verdict
<PASS | REJECT>

## Progress
### Now
<the task this check closes>
### Done
<branches exercised and their result, one line each, or none>
### Open
<what could not be checked, and why, one line each, or none>
### Next
<the next action: accept the task, or the repair it needs>

## Branches
<every condition this change can take, one per line, or none>

## Evidence
### <branch name>
Input:
Expected: <quoted from that REQ>
Command:
Output:

## Kept
### <name>
<what still happens>
<command>
<output>

## Outside
<hunks that touch a file outside owns, one per line, or none>

## Breaks
<what this change breaks, one per line, or none>
```
