# Claude Code

Read this only when the harness is Claude Code.

## Dispatch

`Agent` dispatches a subagent; `Skill` loads a skill. Claude Code nests subagents up to three layers below the main conversation, and `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH` changes that.

The controller is the most expensive seat in a run: it reads every dispatch result and every report. When a whole plan can run one layer down, spawn one orchestrator on a mid-tier model with the plan path, and let it dispatch its own workers and verifiers. Its final message must carry the decisions verbatim — relay them, do not summarize. Do this for a whole plan, never for a single task: nesting one task's dispatch buys nothing and adds a seat.
