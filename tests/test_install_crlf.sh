#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"

# Run install.sh with --all --with-recommended using the local cache.
# It should never output "Thiếu " for existing skills in cache.
#
# A crash is not a pass. `bash install.sh` on a CRLF-corrupted file dies at
# line 2 (`set: pipefail: invalid option name`) before it can print anything,
# so a check that only looks for "Thiếu " reports PASS on a completely broken
# installer. The exit code closes that hole.
set +e
output="$(bash "$root/scripts/install.sh" --all --with-recommended 2>&1)"
status=$?
set -e

if echo "$output" | grep -q "Thiếu "; then
  echo "FAIL: install.sh reported missing skills due to CRLF corruption:" >&2
  echo "$output" | grep "Thiếu " >&2
  exit 1
fi

# install.sh exits 1 when it legitimately finds no IDE on the machine, and
# names that case in its message. Any other non-zero exit means it never got
# far enough to look for a skill at all.
if [[ $status -ne 0 ]] && ! echo "$output" | grep -q "IDE"; then
  echo "FAIL: install.sh exited $status before it could check any skill:" >&2
  echo "$output" >&2
  exit 1
fi

if [[ $status -ne 0 ]]; then
  echo "SKIP: install.sh found no IDE on this machine; nothing to check"
  exit 0
fi

echo "PASS: install.sh ran and reported no missing skills"
