#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: scripts/link-skills.sh <destination-dir>" >&2
  exit 1
fi

root="$(cd "$(dirname "$0")/.." && pwd)"
dest="${1%$'\r'}"
mkdir -p "$dest"

names=(
  c-install
  c-agents
  c-route
  c-scaffold
  c-spec
  c-implement
  c-prompt
  c-loop
  c-process
  c-flow
  c-design
  c-review
  c-refactor
  c-lint
  c-perf
  c-debug
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

legacy=(
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
  reviewing-code
  refactoring-code
  checking-lint
  improving-performance
  debugging-a-failure
  install
  agents
  route
  scaffold
  spec
  implement
  prompt
  loop
  process
  flow
  design
  review
  refactor
  lint
  perf
  debug
)

for name in "${names[@]}"; do
  copy_skill "$root/$name" "$dest/$name"
done

for name in "${legacy[@]}"; do
  if [[ -L "$dest/$name" || -d "$dest/$name" ]]; then
    rm -rf "$dest/$name"
  fi
done

echo "installed ${#names[@]} skills into $dest"
