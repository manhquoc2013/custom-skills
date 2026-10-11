#!/usr/bin/env bash
set -euo pipefail

branch="${CUSTOM_SKILLS_REF:-main}"
url="${CUSTOM_SKILLS_URL:-https://github.com/manhquoc2013/custom-skills/archive/refs/heads/${branch}.tar.gz}"
work="$(mktemp -d "${TMPDIR:-/tmp}/custom-skills.XXXXXX")"
trap 'rm -rf "$work"' EXIT

if [[ -n "${CUSTOM_SKILLS_TARBALL:-}" ]]; then
  tar -xzf "$CUSTOM_SKILLS_TARBALL" -C "$work"
else
  curl -fsSL "$url" | tar -xz -C "$work"
fi

root=""
if [[ -f "$work/scripts/install.sh" ]]; then
  root="$work"
else
  for dir in "$work"/*; do
    if [[ -d "$dir" && -f "$dir/scripts/install.sh" ]]; then
      root="$dir"
      break
    fi
  done
fi

if [[ -z "$root" ]]; then
  echo "Không thấy scripts/install.sh trong bản tải về." >&2
  exit 1
fi

chmod +x "$root/scripts/install.sh" "$root/scripts/link-skills.sh"
"$root/scripts/install.sh" "$@"
