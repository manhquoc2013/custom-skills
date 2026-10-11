---
name: c-perf
description: >-
  Use when the user asks to speed something up, cut latency, or improve
  performance. Use for "cho nhanh hơn", "tối ưu perf", "giảm thời gian".
  No change before a measured baseline.
---

# Improving performance

Measure, then change one thing, then measure again. Questions follow the Questions section of `c-agents`.

## Baseline

The user names the slow path: a command, a request, or a function. When they do not, ask in one form. The recommended choice is the hottest command already in the repo's benchmarks or the endpoint they last complained about.

Run that measurement once and record it in `work/perf/BASELINE.md` under Path, Command, Input size, and Number. No number, no edit. A guess about Big-O is not a baseline.

## One change

Change only the path the measurement exercises. Prefer a smaller working set or one less round trip that the baseline shows. Do not add a cache, an index, or a new dependency for a cost the baseline did not show.

Re-run the same command on the same input. Write `work/perf/RESULT.md` with Before, After, and Functional result on separate lines. Keep the change only when the new number is lower, that result is unchanged, and the repo's test command is still green. A faster number with a different result, or a red test, is rolled back.

Three changes that do not beat the baseline stop. Report the three numbers and leave the code at the baseline.
