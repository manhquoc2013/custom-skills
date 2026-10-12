# CONTEXT.md template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

The frozen design record for a feature. Read it to see what was agreed and what is deliberately excluded. Every heading is filled before plan.

```markdown
# CONTEXT

## Goal
<one sentence: what is true when this work is finished>

## Actor
<who does it>

## Progress
### Now
<the stage this design is at: grilling, accepted, or frozen>
### Done
<what the user has already confirmed, one line each, or none>
### Open
<what is still unconfirmed, one line each, or none>
### Next
<the single next action, or none>

## Requirements
### REQ-1
<what happens>
<what you should see when it works>

## Approach
### Accepted
<the design the user accepted, in a few sentences>
### Also considered
<the other options and why they lost, one sentence each, or none>

## Failure
<the failure, empty, or forbidden case this work must handle>

## Out of scope
<what this work deliberately does not do, one item per line, or none>

## Kept
### <name>
<what still happens after this work>
<the command that shows it>
<that command's output before this work>

## Verify
Test command: <the repo's test command>
Build command: <the repo's build or typecheck command, or none>
<what a pass looks like>

## Source
<docs path, or this prompt>
```
