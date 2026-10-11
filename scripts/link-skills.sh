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
  process
  processing-the-flow
  designing-interface
  reviewing-code
  refactoring-code
  checking-lint
  improving-performance
)

copy_skill() {
  local src="$1" target="$2"
  if [[ -L "$target" ]]; then
    rm "$target"
  elif [[ -d "$target" ]]; then
    rm -rf "$target"
  fi
  mkdir -p "$target"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a "$src/" "$target/"
  else
    cp -R "$src"/. "$target"/
  fi
}

for name in "${names[@]}"; do
  copy_skill "$root/$name" "$dest/$name"
done

echo "installed ${#names[@]} skills into $dest"
