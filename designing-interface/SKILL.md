---
name: designing-interface
description: >-
  Use when the task changes how a screen looks, feels, moves, or is interacted
  with: pages, components, layout, typography, color, motion, charts, or
  accessibility. Use for UI, UX, design system, or giao diện. Skip for backend
  logic that does not change a screen.
---

# Designing an interface

Decide the product's visual system before styling a page. Record it in `design-system/MASTER.md`. Page files under `design-system/pages/` override MASTER for that page only. Read MASTER before regenerating it. Replace it only when the user asks.

If a `ui-ux-pro-max` search script is installed, query it with one intent of 2–5 words. Use `--design-system` for a new product or page, `--domain` for one concern, `--stack` for the framework detected from the manifest. Persist with `--output-dir` at the repo root. When the script is absent, write MASTER from the checks below and say the brief is checklist-derived.

Detect the stack from the manifest. Ask when it is ambiguous. A dashboard wants dense spacing. A marketing page wants sparse spacing. Pick one.

## MASTER.md

```markdown
## Product
type, audience, style words
## Stack
## Color
semantic tokens and the pairs that meet 4.5:1
## Type
family, body 16px, line-height 1.5
## Space
density and the spacing steps
## Motion
what moves, and the reduced-motion fallback
## Reuse
existing components this product already has
## Anti-patterns
styles and patterns this product rejects
```

Match one style to the product. Keep icons as SVG with a text name. Put raw hex in the token file, and reference tokens from components.

## Checks, in order

1. Contrast 4.5:1, visible focus, a name on every icon button. Icons are SVG, not emoji.
2. Targets at least 44px, gaps at least 8px, a loading state for every wait. No action that exists only on hover.
3. Images have reserved space and lazy-load when offscreen. Lists that can grow are windowed.
4. Breakpoints are mobile-first. No horizontal scroll. Zoom stays on. A phone nav has at most 5 items, and the screen has a deep link.
5. Body text stays at least 16px. Errors sit on the field, labels stay visible without the placeholder. A long form reveals later fields after the first valid step.
6. Motion explains a change. Exits are shorter than enters. Do not animate width or height. `prefers-reduced-motion` disables non-essential motion.
7. Back navigation returns to the same place. Charts do not use color as the only encoding.
8. Empty, loading, and error each have their own layout.

## Coordination

Read and follow `coordinating-agents` when more than one page is built. One worker owns `design-system/MASTER.md`. Each other worker owns one page file. The verifier for a page re-checks the checklist and the browser flow. The skill is done only when those rows are `pass`.

## Done

MASTER.md exists and the screen uses it. The changed flow has been exercised in the browser, including the empty and error states the change can reach. A screenshot alone does not finish the skill.
