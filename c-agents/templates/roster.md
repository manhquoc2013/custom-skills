# roster.md template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

The agent roster for one run. Use `work/{slug}/roster.md` when a feature slug exists, otherwise `work/roster.md`. Write it before the first dispatch, one heading per agent. Read it to see who is working, on what, and how far each has got. Update `Status` when that agent is dispatched, when it returns, and when the verdict is in.

In the file below, `## Progress` is the run summary and every other `##` heading is an agent id.

```markdown
## Progress
### Now
<the wave or gate this run is in>
### Done
<agents already returned with a verdict, one line each, or none>
### Open
<agents still running or blocked, one line each, or none>
### Next
<the next dispatch, or the verdict still owed>

## <agent id>
Role: <coordinator | worker | verifier>
Task: <the skill name, or the task id>
Owns: <one path per line, or none>
Status: <assigned | running | returned | verifying | pass | reject>
Reached: <what this agent has handed back so far, or none>
Blocked by: <what stops it, or none>
```
