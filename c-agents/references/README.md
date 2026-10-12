# Harness files

One file per harness, read only when the harness matches. `## Harness` in `../SKILL.md` is the list; nothing else keeps a copy.

Verified, with a file here:

| Harness | File |
|---------|------|
| Claude Code | `claude-code.md` |
| Codex | `codex.md` |
| Antigravity | `antigravity.md` |
| Cursor | `cursor.md` |

Every other harness this pack installs into — the rest of `scripts/agents.tsv` — uses the neutral path in the section that sent you: reach MCP tools through your harness's own discovery, dispatch through your own subagent call, and ask the user in one message. Nothing here is guessed for those.

To add one: run the action on that harness, note the real tool names and flags, then add `references/<harness-id>.md` and a line under `## Harness` in `../SKILL.md`. Never copy a name from another harness's file, a table, or memory.
