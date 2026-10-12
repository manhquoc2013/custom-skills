---
name: c-prompt
description: >-
  Use when the user asks to viết prompt, write or rewrite a prompt, agent brief,
  slash command, automation instruction, or the text that will drive an agent
  run or a loop.
---

# Prompting the loop

The deliverable is one prompt another session can run without the author in the room. Fill every section of `templates/prompt.md`, next to this file. A section that says "use your judgment" is unfinished. A question to the user follows the Questions section of `c-agents`.

Level defaults to L1. L2 and L3 require a verifier command and a state path. L3 also requires a budget cap, a kill switch, and a line that L1 reports were accurate for a week. A prompt that edits code stays L2 until that line is true, and is unfinished without the command for behavior the run must leave unchanged.

Match the level to the blast radius. Auth, payments, secrets, and infra stay human-merged at every level.

Write the prompt into the file the user named. When they did not name one, write `prompts/{name}.md` and show the path.

## Coordination

Read and follow `c-agents` when more than one prompt is written. One worker owns one prompt file. The verifier checks that every section has a concrete value and that Done when names a command. The skill is done only when each prompt row is `pass`.

## Done

Every section has a concrete value, the done checks are commands or file facts, and the verifier is a different pass from the author of the change.
