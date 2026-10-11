---
name: process
description: >-
  Use when the user types /process with a feature, bug, or idea. This is the
  short command for processing-the-flow. The words after /process are the request.
---

# Process

`/process` is the short name of `processing-the-flow`. The words after the command are the request.

The first lookup is MCP `codegraph_explore`. It often is not a normal function. On Cursor, `GetDynamicTools` for the codegraph namespace, then `CallDynamicTool` with tool name `codegraph_explore`, using the user's words. Do not say the tool is absent, lazy, or unregistered before that discovery. Grep and `Searched <word>` do not count.

Then read `processing-the-flow/SKILL.md` next to this file and follow its Lookup and Grill sections. Questions follow the Questions section of `coordinating-agents`: one letter per proposal, last choice `Người dùng quyết định`. A paragraph that says "Yes" is not a question. This turn does not edit product code.
