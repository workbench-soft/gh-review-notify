# Changelog

## Unreleased

- **CI** the release notes test sets its own `GITHUB_REPOSITORY`, so it passes on the runner, where GitHub sets one.

- **Reseed** a run without `seen.txt` reads every PR again, so old events of a PR stay quiet when it changes later. Before, they popped up as new.
- **Private cache** `~/.cache/gh-review-notify` is readable by your account only, the folder of an older install too. Before, other Mac accounts could list your private PR URLs.
- **Log** each error line starts with its time, and the log keeps its last 1000 lines once it passes 1 MB.
- **Help** `--help` lists the options, and an unknown option stops with the list. Before, both ran a full check of GitHub.
- **Missing tools** the install checks gh, jq and terminal-notifier in the folders the agent searches, and the run names those folders when gh or jq is missing. Before, a jq from mise passed the install and every run failed.
- **Newest first** each search keeps the 100 most recently updated PRs, so a fresh review request isn't cut past 100 open ones.
- **Battery** the agent runs as a macOS background job, and `seen.txt` is rewritten only once it passes 3000 keys.
- **Messages** `--status` says "offline or logged out" when the account check fails, a failed first install run points at the message on screen, and the install summary gives the full path when `~/.local/bin` is off PATH.
- **CI** lint finds each shell script through `shfmt -f`, the pre-push hook included. Dependabot keeps the action pins current, mise-action is 5.2.7, release notes drop `Co-Authored-By` trailers, and tests cover the bots setting, the lock and the comment fold.

- **Lint before the push** a pre-push hook runs `mise run lint`, so a lint or format error stays on the PC instead of failing Checks on `main`.

- **Docs** the README and the release spec say the script checks its settings at each run, and that Release starts on `workflow_run` of shellcheck.

- **CI** Release starts on `workflow_run` once shellcheck passes on `main`, one at a time. No job holds a runner while it waits.

- **CI** `gh release create` makes the tag with the release, so a failed publish leaves no stray tag. The Release comments say what each step does, the guard script is the `repo-ci` one with its run bit, and the docs lose the agent rules pasted in by the CI rollout.
- **Parallel release builds** releases build beside checks after a push. Only publication waits for matching checks; open PRs hold no build.

- **CI** Release waits while a PR of an agent session is open, so the last merge of a batch releases them all.
- **Settings** a run with a bad `GH_REVIEW_NOTIFY_DAYS` or `GH_REVIEW_NOTIFY_BOTS` stops and says what it takes. Before, it called GitHub with a broken date and logged a GitHub failure.
- **CI** mise pins `jq` and runs the tests through `mise run test`. Both workflows check out with the same `actions/checkout` release.
- **Docs** each heading of `docs/features.md` links its spec, and each feature that had no spec got one.
- **Markdown** markdownlint-cli2 lints the docs in `mise run lint`.

- **Architecture decisions** `docs/architecture.md` gets a Decisions section. Each big choice names its reason, its cost and the rivals it beat.

- **Lint and format** shfmt formats the scripts and oxfmt the Markdown. CI runs `mise run lint` with shellcheck.

- **Releases** each push to `main` that passes `shellcheck` gets a GitHub release such as `v2026.10.30.1`. Its notes list the commits since the release before.
- **Public** the repo is open source. CI runs on a GitHub macOS runner in place of the Windows PC.
- **Status** `--status` says whether the agent runs right now or waits for its next run. Before, it said "running" in both cases.
- **Offline log** a run without network logs "Check the network, or run gh auth login". Before, it said gh was logged out.
- **Install settings** `install.sh` stops on a bad interval, days or bots value and says what it takes. Before, the value went into the agent and broke it.
- **Update** a failed download during `install.sh` keeps the installed script. Before, the running agent got an empty or half written script.
- **PR titles** a backslash in a PR title shows once on an approval with no text. Before, it showed twice.
- **Edited comments** an old comment on the conversation tab, edited today, stays silent. Before, it popped up as new with its old date.
- **Review requests** a failed reviewer lookup is asked again on the next run. Before, the request counted as a team request and stayed silent.
- **Search errors** a failed GitHub search stops the run and keeps the caches. On the first run any failed call stops it, so a first install during an outage no longer floods the next run with 3 days of old events.
- **CI** runs on pushes to main only. PR runs are off, and the workflow says how to turn them back on.
- **CI** a newer push to main or to a PR cancels the checks and deploys still running for the older commit.
