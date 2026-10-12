# Antigravity

Read this only when the harness is Antigravity.

## Dispatch

`invoke_subagent` takes a built-in `TypeName`: `self` for full-capability work, `research` for read-only.

## Task tracking

Antigravity has no todo tool. `manage_task` manages background processes (`list`, `kill`, `status`, `send_input`) — it is not a checklist. Keep the plan as a task artifact instead: a markdown checklist saved with `write_to_file` (`IsArtifact: true`, `ArtifactMetadata.ArtifactType: "task"`) and edited with `replace_file_content` as you go. Re-read it before each step once the conversation gets long.
