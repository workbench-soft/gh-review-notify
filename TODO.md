# TODO

## rewrite-repo

- [ ] Run `./install.sh` on the Mac and wait for a real review notification. The rewrite was checked on Windows with stubs only: `launchctl`, `osascript` and the BSD `date` didn't run.
- [ ] Watch the first CI run on the Windows PC runner: it now installs `jq` through winget and runs `tests/run.sh`. `.github/workflows/shellcheck.yml`

## reset-history

- [ ] Each other clone, the Mac included: run `git fetch` then `git reset --hard origin/main`. A push from an old clone brings the history back.
- [ ] Delete the backup bundle once the new history has settled: `~/repo-backups/gh-review-notify-20251029-085602.bundle` on the Windows PC.
- [ ] GitHub keeps `refs/pull/1/head` and `refs/pull/2/head` on old commits, and the PR pages still show them. Only GitHub Support can remove them.

## app-audit

- [ ] Run `./install.sh` again on the Mac, then check that `gh-review-notify --status` reads "loaded, waiting for the next run". The audit fixes ran on Windows with stubs only: `launchctl`, `osascript` and BSD `date` didn't run (branch `audit-2026-10-30`).
- [ ] After the merge, watch the shellcheck run on main. The new brew branch of the install steps runs only when the job lands on the Mac runner. `.github/workflows/shellcheck.yml`
- Left: a re-requested review stays silent, since `#review-requested` is already in `seen.txt`. The fix needs the PR timeline API and a new event key, effort M.
- Left: gh calls have no timeout. Stock macOS has no `timeout` command, and launchd doesn't start a second run while one runs.
- Left: the cache files carry no format number. A new format can take a new file name, and the script then reseeds quietly.
- Left: `install.sh` and `--status` have no test. They need stubs for `launchctl`, `stat` and `brew`, effort M.
- Left: an old inline diff comment edited today still pops up. Filtering it by creation time could hide a draft review sent days later, so GitHub's draft timestamps need checking first.
- Left: no `mise.toml` pins shellcheck and jq. CI installs them through brew or winget, so a pin pays off only once CI runs mise too.
