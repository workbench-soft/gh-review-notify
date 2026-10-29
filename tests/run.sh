#!/bin/bash
# Runs gh-review-notify twice against canned GitHub answers and compares the
# notifications and API calls with expected.txt. Pass --update to rewrite it.
set -euo pipefail

tests=$(cd "$(dirname "$0")" && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# The script pins PATH to the Homebrew folders. The copy puts the stubs first.
# shellcheck disable=SC2016
sed 's|^export PATH=.*|export PATH="$STUBS:$PATH"|' "$tests/../gh-review-notify" > "$work/gh-review-notify"

export REAL_JQ
REAL_JQ=$(command -v jq)
export STUBS="$tests/stubs"
export XDG_CACHE_HOME="$work/cache"
export GH_CALLS="$work/calls.txt"
export NOTIFICATIONS="$work/notifications.txt"
export NOW=1761739200 # 2025-10-29T12:00:00Z
unset GH_REVIEW_NOTIFY_DAYS GH_REVIEW_NOTIFY_BOTS

run() { # fixture set, arguments
  : > "$GH_CALLS"
  : > "$NOTIFICATIONS"
  local status=0
  FIXTURES="$tests/fixtures/$1" bash "$work/gh-review-notify" "${@:2}" || status=$?
  echo "exit $status"
  echo "-- gh calls"
  cat "$GH_CALLS"
  echo "-- notifications"
  cat "$NOTIFICATIONS"
}

{
  echo "== first run, logged out"
  run logged-out
  echo "== first run"
  run seed
  cp -R "$XDG_CACHE_HOME" "$work/seeded-cache"
  echo "== second run"
  run next
  echo "== --test"
  run next --test

  # Without terminal-notifier the script falls back to osascript.
  mkdir "$work/osascript-stubs"
  cp "$STUBS"/* "$work/osascript-stubs/"
  rm "$work/osascript-stubs/terminal-notifier"
  rm -rf "$XDG_CACHE_HOME"
  cp -R "$work/seeded-cache" "$XDG_CACHE_HOME"
  echo "== second run, osascript"
  STUBS="$work/osascript-stubs" run next
} > "$work/actual.txt" 2>&1

if [ "${1:-}" = "--update" ]; then
  cp "$work/actual.txt" "$tests/expected.txt"
  echo "Wrote tests/expected.txt"
elif diff -u "$tests/expected.txt" "$work/actual.txt"; then
  echo "Pass"
else
  echo "Fail: the output above differs from tests/expected.txt" >&2
  exit 1
fi
