# Changelog

## Unreleased

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
