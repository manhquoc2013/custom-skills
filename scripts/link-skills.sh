#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: scripts/link-skills.sh <destination-dir>" >&2
  exit 1
fi

root="$(cd "$(dirname "$0")/.." && pwd)"
dest="$1"
mkdir -p "$dest"

names=(
  installing-skills
  coordinating-agents
  routing-engineering-work
  scaffolding-project
  specifying-a-feature
  implementing-from-spec
  prompting-the-loop
  running-the-loop
  processing-the-flow
  designing-interface
)

for name in "${names[@]}"; do
  ln -sfn "$root/$name" "$dest/$name"
done

echo "linked ${#names[@]} skills into $dest"
