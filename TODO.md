# TODO

## rewrite-repo

- [ ] Run `./install.sh` on the Mac and wait for a real review notification. The rewrite was checked on Windows with stubs only: `launchctl`, `osascript` and the BSD `date` didn't run.

## reset-history

- [ ] Each other clone, the Mac included: run `git fetch` then `git reset --hard origin/main`. A push from an old clone brings the history back.
- [ ] Delete the backup bundle once the new history has settled: `~/repo-backups/gh-review-notify-20261029-085602.bundle` on the Windows PC.
- [ ] GitHub keeps `refs/pull/1/head` and `refs/pull/2/head` on old commits, and the PR pages still show them. Only GitHub Support can remove them.

## app-audit

- [ ] Run `./install.sh` again on the Mac, then check `gh-review-notify --status`, `gh-review-notify --help` and the install summary. The 2026-11-11 audit ran on Windows with stubs only: `launchctl`, `plutil`, `osascript` and BSD `date` didn't run (PR #7, #14 and #20).
- [ ] On the Mac, check that the cache folder shows `drwx------` after one run: `ls -ld ~/.cache/gh-review-notify`.
- Left: a re-requested review stays silent, since `#review-requested` is already in `seen.txt`. The fix needs the PR timeline API and a new event key, effort M.
- Left: gh calls have no timeout. Stock macOS has no `timeout` command, and launchd doesn't start a second run while one runs.
- Left: the cache files carry no format number. A new format can take a new file name, and the script then reseeds quietly.
- Left: `install.sh` and `--status` have no test. They need stubs for `launchctl`, `stat` and `brew`, effort M.
- Left: an old inline diff comment edited today still pops up. Filtering it by creation time could hide a draft review sent days later, so GitHub's draft timestamps need checking first.
- Left: the `--author` search repeats part of `--involves`. Dropping it saves 1 search per run, but the seed, next and fetch-fails fixtures need merging first.
- Left: a release cancelled by a newer one can leave a pushed tag without a release. The next run picks the next number, so only a gap shows.
- Left: a run killed between the `pr-updated.tsv` write and the `seen.txt` append, or between `seen.txt` and the notifications, loses those events. Lost or doubled is a product call.
- Left: two runs that find a stale lock in the same instant can both run. It needs a crash plus two starts at once, and the 15 minute expiry ties to the gh timeout item.
- Left: `--status` shows the mtime of `pr-updated.tsv` as the last run, and failed runs touch it too. What it shows is a product call.
- Left: failing runs show only in `--status` and the log. A warning notification is a product call.
- Left: each search stops at 100 PRs with no warning. Paging or a warning is a product call; the searches now keep the newest 100.
- Left: terminal-notifier might misread a message that starts with `-`. A guess that needs a Mac to prove.
- Left: release notes sort into New, Fixes and Faster only by `feat:`, `fix:` and `perf:` subjects, which this repo doesn't write. The change belongs in the shared repo-ci template.
- Left: the agent label and the log path sit in 3 files with no check. The installed script runs alone and can't source a shared file.
- Left: oxfmt 0.75 and node 24 trail the latest. The org pins in `stack` move all repos together.
- Left: the workflow is `shellcheck.yml`, where `stack` says `checks.yml`. Release and the local-ci page key off the name.
- Left: `applescript_text` escapes by hand where `osascript` argv would do. It is correct today, and the swap changes the stubs and the expected output.
