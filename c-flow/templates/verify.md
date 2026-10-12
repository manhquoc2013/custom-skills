# VERIFICATION.md template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

The whole-feature verification record, written at the verify gate. Read it to see whether every requirement and every kept behavior was re-run and matched.

```markdown
## Verdict
<PASS | REJECT>

## Progress
### Now
<the verify gate, and which feature it covers>
### Done
<requirements and kept rows already checked and matched, one line each, or none>
### Open
<gaps and outside behaviors still open, one line each, or none>
### Next
<the next action: ship, or the repair this verdict needs>

## Requirements
### REQ-1
Expected: <quoted from CONTEXT>
Command:
Output:

## Kept
### <name>
Prior result:
Command:
Output:

## Outside
<behaviors that changed outside the plan, one per line, or none>

## Gaps
<requirement ids with no matching output, one per line, or none>
```
