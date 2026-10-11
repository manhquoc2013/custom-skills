---
name: coordinating-agents
description: >-
  Use when a skill in this pack splits work or dispatches a subagent. Use when
  assigning agents, tracking what an agent will do or is doing, or deciding
  that assigned work is finished.
---

# Coordinating agents

The parent session is the coordinator. It may do a one-part job itself. Splitting work or dispatching a subagent uses this skill.

## Superpowers

Cursor does not load a Superpowers skill unless this pack tells the agent to read it. When a row matches, read that skill and follow it before the action.

| Situation | Read and follow |
|-----------|-----------------|
| Behavior is not approved yet | `brainstorming` |
| Multi-step work has no plan yet | `writing-plans` |
| About to edit the tree for a feature | `using-git-worktrees` |
| About to write production code | `test-driven-development` |
| Bug, red test, or no command yet that fails on the reported symptom | `systematic-debugging` |
| Two or more workers with disjoint files | `dispatching-parallel-agents` |
| A worker just returned | `requesting-code-review` |
| About to claim pass, done, or fixed | `verification-before-completion` |
| Branch is ready to merge or open a PR | `finishing-a-development-branch` |

## Roster

Write the roster before the first dispatch. Use `work/{slug}/roster.md` when a feature slug exists. Otherwise use `work/roster.md`. One row per agent. Update `status` when that agent is dispatched, when it returns, and when the verdict is in.

```markdown
| id | role | task | owns | status |
| parent | coordinator | the skill name | none | running |
```

- **coordinator** assigns rows and does not do a worker's task.
- **worker** has one task and one file list. Two workers do not share a task or a file.
- **verifier** is a new subagent for that worker. It is read-only, re-runs the done check, and does not continue the worker's context.
- **watcher** is one read-only agent per parallel batch. It reports any file two workers touched, or a file outside a worker's `owns` cell.

Status moves `assigned` → `running` → `returned` → `verifying` → `pass` or `reject`.

A row is finished only at `pass`: the verifier ran the done check, the actual output matches the task, and the watcher found no overlap. The worker's own done sentence is not `pass`.

## Dispatch

Rows with disjoint files go out in one response. Read and follow `dispatching-parallel-agents`. Each prompt contains only that row's task, `owns` list, and done check. The worker writes `work/{slug}/agents/{id}.md`, or `work/agents/{id}.md` when there is no slug, with the files it touched and the command output. It does not write the verdict.

After those workers return, dispatch their verifiers and one watcher in the same response.

## Parent does the work

A single part with no second file owner stays in the parent. The parent still writes its own row and a verifier row. The verifier is a different pass: a new subagent, or a second pass that re-runs the done check and writes the verdict. The parent does not mark its own row `pass`.

## Stop

Overlap, an edit outside `owns`, or three rejects on the same row stops that batch. Record the row as `reject`. Re-dispatch only the rejected worker.
