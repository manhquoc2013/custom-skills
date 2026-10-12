# waves/{wave}.md template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

The synthesis file for one wave. Read it to see which tasks passed, what each one proved, and whether the wave may advance.

```markdown
## Verdict
<PASS | REJECT>

## Progress
### Now
<the wave this record closes, and whether it advanced>
### Done
<tasks that passed and what each proved, one line each, or none>
### Open
<tasks still failing and what blocks each, one line each, or none>
### Next
<the next wave id to dispatch, or verify>

## Tasks
### T1
Row: <the row id that carries this task>
REQ: <REQ id>
Owns: <one path per line>
Status: <assigned | running | returned | verifying | pass | reject>
REQ command:
REQ output:
Kept command:
Kept output:

## Conflicts
<files claimed by two rows, or from outside owns, one per line, or none>
```
