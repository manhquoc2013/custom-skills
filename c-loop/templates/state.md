# STATE.md template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

One loop's state file. Every run reads it first and deletes lines whose PR or issue is already closed. Read it to see what the loop watches, what it already handled, and whether it is paused.

```markdown
# STATE

## Level
<L0 | L1 | L2 | L3>

## Progress
### Now
<the loop pattern, and when it last ran>
### Done
<items the loop already closed, one line each, or none>
### Open
<items still being worked, one line each, or none>
### Next
<what the next run will do>

## High priority
### <item>
Action: <what the loop will do about it>
Attempts: <0-3>

## Watch
<none, or one item per heading>

## Waiting on human
<none, or one item per heading>

## Last run
<timestamp>

## Kill switch
paused: <true | false>
```
