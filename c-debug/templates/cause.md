# CAUSE.md template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

The cause record for one failure. `--find` writes it and stops; `--fix` starts only after `Cause` is quoted. Read it to see what was reproduced, what was ruled out, and where the bad value is first produced.

```markdown
## Mode
<find | fix>

## Progress
### Now
<the failure being traced>
### Done
<what has been reproduced and ruled out, one line each, or none>
### Open
<what is still unexplained or unrepaired, one line each, or none>
### Next
<the next action: keep tracing, or repair>

## Symptom
Expected:
Actual:

## Red command
Command:
Output:

## Working
<the similar green path and the one difference, or none>

## Cause
<the site that first produced the bad value>

## Discarded
### <hypothesis>
Command:
Output:

## Seam
<where a regression test can fail on this symptom, or no seam>
```
