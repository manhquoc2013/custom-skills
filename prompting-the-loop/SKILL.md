---
name: prompting-the-loop
description: >-
  Use when the user asks to viết prompt, write or rewrite a prompt, agent brief,
  slash command, automation instruction, or the text that will drive an agent
  run or a loop.
---

# Prompting the loop

The deliverable is one prompt another session can run without the author in the room. Fill every section. A section that says "use your judgment" is unfinished.

```markdown
# {name}

## Goal
One sentence: the observable outcome of a single run.

## Non-goals
What this run leaves untouched.

## Read first
Files, tickets, and prior state. Name the paths.

## Steps
Ordered actions. Each step ends when a checkable condition is true.

## Done when
Checks a different pass can run: commands, files, or a state field.

## Verifier
Who checks, and the instruction "find reasons to reject". The author of the change does not grade it. Name the test or audit command.

## Constraints
Denylist paths. Max files. Max attempts (default 3), then escalate.
Level: L1 report, L2 assisted fix, or L3 unattended.

## State
Path to read at start and write at end: items, attempts, timestamp, escalations.

## Escalate when
Ambiguity, denylist touch, attempt cap, or repeated identical failure.
```

Level defaults to L1. L2 and L3 require a verifier command and a state path. L3 also requires a budget cap and a kill switch in the state file.

Match the level to the blast radius. Report and draft prompts stay L1. A prompt that edits code is L2 until the same verifier has been right across several runs. Auth, payments, secrets, and infra stay human-merged at every level.

Write the prompt into the file the user named. When they did not name one, write `prompts/{name}.md` and show the path.

## Done

Every section has a concrete value, the done checks are commands or file facts, and the verifier is a different pass from the author of the change.
