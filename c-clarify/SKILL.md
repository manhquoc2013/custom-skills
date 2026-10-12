---
name: c-clarify
description: >-
  Use when the user hands over a document and wants the gaps turned into
  questions — a spec, requirements, PRD, or ticket whose business rules,
  technical requirements, or scope are still open. Use for kiểm tra tài liệu,
  soi spec, câu hỏi nghiệp vụ, yêu cầu kỹ thuật chưa rõ.
---

# Clarifying a document

Turn a document's open points into questions. No plan, no code, no verdict in this skill. The deliverable is a question list the user answers before any other skill starts.

## Source

The document is a file path, a pasted block, or the conversation so far. Read a file in full before asking anything. A paste is the whole source. Name no source and ask for it once, then stop until it arrives.

## Mine the gaps

Read the document and mark every place it is silent, vague, or self-contradicting. Cover, in order:

- Business rules — the "when X, what happens" the doc never states: permissions, limits, timing, who, fees, states.
- Technical requirements — the "how" it never states: integrations, data, constraints, performance, errors, environment.
- Scope — what is in, what is out, what is deferred, what depends on another team.
- Edge cases — empty, duplicate, missing, concurrent, partial failure, invalid input, rollback.
- Acceptance — how the user would see the result is right, as one observable outcome.

A term used before it is defined is a gap, not a lookup. A rule that contradicts another line is a gap, not a preference.

## Write the questions

One question per line, grouped under the five headings. Number them `Q1`, `Q2`, … across the whole list so answers map back. Each question names the gap it came from; quote the doc line when the doc has one. Skip a heading with nothing under it. Where the doc is silent and the answer is safe to assume, state the assumption under a sixth heading `Assumptions` instead of asking.

Do not answer a question, propose a design, or turn a gap into a plan. The list is the whole deliverable. A gap that is really a decision with clear choices gets A/B/C per the Questions section of `c-agents`.

## Done

Every question names a real gap with its source line where one exists; nothing is answered, planned, or designed; the five headings carry only their own questions; assumptions are stated, not hidden. The user can answer in one pass and each answer maps to a `Q` id. With a slug, offer to save the settled list to `work/{slug}/QUESTIONS.md` so `c-spec` reads it instead of re-asking.
