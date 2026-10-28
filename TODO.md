# TODO

## rewrite-repo

- [ ] Run `./install.sh` on the Mac and wait for a real review notification. The rewrite was checked on Windows with stubs only: `launchctl`, `osascript` and the BSD `date` didn't run.
- [ ] Watch the first CI run on the Windows PC runner: it now installs `jq` through winget and runs `tests/run.sh`. `.github/workflows/shellcheck.yml`
- [ ] The `osascript` fallback in `show_notification` breaks on a backslash in a comment. It only runs when `terminal-notifier` is missing. `gh-review-notify`

## reset-history

- [ ] Each other clone, the Mac included: run `git fetch` then `git reset --hard origin/main`. A push from an old clone brings the history back.
- [ ] Delete the backup bundle once the new history has settled: `~/repo-backups/gh-review-notify-20261029-085602.bundle` on the Windows PC.
- [ ] GitHub keeps `refs/pull/1/head` and `refs/pull/2/head` on old commits, and the PR pages still show them. Only GitHub Support can remove them.
