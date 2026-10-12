# Fog — the map

Name the destination in one or two lines (a spec, a decision, or a change). Write `work/maps/{slug}.md` from `templates/map.md`.

Each open decision is its own note under `work/maps/{slug}/` with `## Question` and a type: research, prototype, grilling, or task. A question that cannot be phrased sharply stays under Not yet specified. Work past the destination goes under Out of scope.

Grilling and prototype decisions need the user in the loop. Research can run without them. Record the answer on the decision, gist it in Decisions so far, and graduate any fog that is now a sharp question.

A prototype decision answers one question in throwaway code. Delete it unless the user keeps it. It is not the feature.

If charting shows the whole route is already clear, drop the map and use the open-feature path.

Several independent subsystems are not one spec. Name the pieces, ask which is first, and specify only that piece.
