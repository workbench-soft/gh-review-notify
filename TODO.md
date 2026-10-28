# TODO

## rewrite-repo

- [ ] Run `./install.sh` on the Mac and wait for a real review notification. The rewrite was checked on Windows with stubs only: `launchctl`, `osascript` and the BSD `date` didn't run.
- [ ] Watch the first CI run on the Windows PC runner: it now installs `jq` through winget and runs `tests/run.sh`. `.github/workflows/shellcheck.yml`
- [ ] The `osascript` fallback in `show_notification` breaks on a backslash in a comment. It only runs when `terminal-notifier` is missing. `gh-review-notify`
