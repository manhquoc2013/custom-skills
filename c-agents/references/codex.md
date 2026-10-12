# Codex

Read this only when the harness is Codex.

## Multi-agent support

Dispatch needs the multi-agent tools enabled in `~/.codex/config.toml`:

```toml
[features]
multi_agent = true
```

Trust your actual tool list over any table — including this one — when the two disagree.

## Dispatch

- Spawn children with `spawn_agent {fork_turns: "none"}`. The default copies your whole transcript into the child, which costs tokens and pollutes the child's context.
- Set `model` and `reasoning_effort` explicitly. `model` alone is a trap: the child's effort silently resets to that model's default, not to yours.
- Resume an implementer for a fix round with `followup_task`. Never dispatch a fresh one on the theory that a spawned agent cannot be messaged again.
- Never copy a model name out of a skill, a table, or an old session without checking it against your current spawn allowlist.

## Waiting

`wait_agent` is an event subscription, not a poll: a long wait wakes the moment a child produces activity, at the same latency as a short one. While you still have local work, do not wait at all — a finished child's answer arrives with your next turn. When you are idle with children outstanding, wait in stretches of 5 to 10 minutes and reconcile after each one. Measured: roughly two thirds of wait calls were short polls that timed out.
