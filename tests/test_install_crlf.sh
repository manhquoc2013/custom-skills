#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"

# Run install.sh with --all --with-recommended using the local cache
# It should never output "Thiếu " for existing skills in cache
output="$(bash "$root/scripts/install.sh" --all --with-recommended 2>&1 || true)"

if echo "$output" | grep -q "Thiếu "; then
  echo "FAIL: install.sh reported missing skills due to CRLF corruption:" >&2
  echo "$output" | grep "Thiếu " >&2
  exit 1
fi

echo "PASS: No missing skill errors"
