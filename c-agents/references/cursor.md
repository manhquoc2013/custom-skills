# Cursor

The pack's one shared harness file. Every skill points here instead of keeping its own copy. Read it when the harness is Cursor; on every other harness use the neutral path in the skill that sent you here.

## Code graph lookup

Call `GetDynamicTools` for the codegraph namespace, then `CallDynamicTool` with tool name `codegraph_explore`. Pass the user's words (the symbol, the screen, the behavior). One call. Then ask the frontier and stop.

## Frontend lookup

A screen, component, token, or XAML fact is one frontend MCP call — `get_ui_component`, `get_ui_catalog`, or `audit_ux_interface` — after the same `GetDynamicTools` discovery, when that server exists.

## One form per round

One `AskQuestion` call carries the whole form. Do not call it once per question, and do not send the next question after a single answer.
