#!/bin/bash
# Runs gh-review-notify twice against canned GitHub answers and compares the
# notifications and API calls with expected.txt. Pass --update to rewrite it.
set -euo pipefail

tests=$(cd "$(dirname "$0")" && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# The script pins PATH to the Homebrew folders. The copy uses the stubs and the
# system folders only, so a real gh or terminal-notifier on the Mac stays out.
# shellcheck disable=SC2016
sed 's|^export PATH=.*|export PATH="$STUBS:/usr/bin:/bin"|' "$tests/../gh-review-notify" > "$work/gh-review-notify"

export REAL_JQ
REAL_JQ=$(command -v jq)
export STUBS="$tests/stubs"
export XDG_CACHE_HOME="$work/cache"
export HOME="$work/home"
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
  echo "== first run, a search fails"
  run search-fails
  echo "== first run, a reviewer lookup fails"
  run lookup-fails
  echo "== first run, a review list fails"
  run fetch-fails
  echo "== first run"
  run seed
  echo "-- umask of the run: $(cat "$GH_CALLS.umask")"
  cp -R "$XDG_CACHE_HOME" "$work/seeded-cache"
  # Without seen.txt the run seeds again, and reads every PR despite pr-updated.tsv.
  rm "$XDG_CACHE_HOME/gh-review-notify/seen.txt"
  echo "== first run again, seen.txt deleted"
  run seed
  echo "== second run"
  run next
  echo "== third run, nothing new, a log past 1 MB"
  mkdir -p "$HOME/Library/Logs"
  for i in $(seq 1 15000); do echo "$i A GitHub call failed. The next run tries again. Some padding text."; done > "$HOME/Library/Logs/gh-review-notify.log"
  run next
  echo "-- log lines left: $(wc -l < "$HOME/Library/Logs/gh-review-notify.log" | tr -d ' '), last: $(tail -n 1 "$HOME/Library/Logs/gh-review-notify.log" | cut -d' ' -f1)"
  echo "== --test"
  run next --test
  echo "== --help"
  run next --help
  echo "== unknown option"
  run next --stauts
  echo "== bad setting, GH_REVIEW_NOTIFY_DAYS=3d"
  GH_REVIEW_NOTIFY_DAYS=3d run next
  echo "== bad setting, GH_REVIEW_NOTIFY_BOTS=yes"
  GH_REVIEW_NOTIFY_BOTS=yes run next

  # Without terminal-notifier the script falls back to osascript.
  mkdir "$work/osascript-stubs"
  cp "$STUBS"/* "$work/osascript-stubs/"
  rm "$work/osascript-stubs/terminal-notifier"
  rm -rf "$XDG_CACHE_HOME"
  cp -R "$work/seeded-cache" "$XDG_CACHE_HOME"
  echo "== second run, osascript"
  STUBS="$work/osascript-stubs" run next

  # gh outside the Homebrew folders is missing for the agent, whatever the shell finds.
  mkdir "$work/no-gh-stubs"
  cp "$STUBS"/* "$work/no-gh-stubs/"
  rm "$work/no-gh-stubs/gh"
  echo "== gh missing"
  STUBS="$work/no-gh-stubs" run next

  # An empty PATH stops install.sh at its macOS check if a bad value gets past.
  for setting in GH_REVIEW_NOTIFY_INTERVAL=3m GH_REVIEW_NOTIFY_DAYS=0 GH_REVIEW_NOTIFY_BOTS=yes; do
    echo "== install.sh, $setting"
    env -i HOME="$work/home" PATH=/nonexistent "$setting" "$BASH" "$tests/../install.sh" || echo "exit $?"
  done

  # The release scripts read the tags and commits of a scratch repo with fixed
  # dates, so the short hashes stay the same. The date stub sets the day.
  export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1 GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com
  export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com GIT_AUTHOR_DATE=@$NOW GIT_COMMITTER_DATE=@$NOW
  git init -q "$work/repo"
  (
    cd "$work/repo"
    git commit -q --allow-empty -m "First release"
    git tag v2025.10.29.1
    git commit -q --allow-empty -m "fix: keep the caches" -m "Co-Authored-By: someone <someone@example.com>"
    git commit -q --allow-empty -m "Show the PR title" -m "The reason." -m "Details for developers."
    echo "== next-version.sh"
    PATH="$STUBS:$PATH" sh "$tests/../.github/scripts/next-version.sh"
    echo "== release-notes.sh"
    sh "$tests/../.github/scripts/release-notes.sh" v2025.10.29.2
  )
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
