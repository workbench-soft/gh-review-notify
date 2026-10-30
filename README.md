# gh-review-notify

Your Mac pops a notification when a person reviews or comments on your pull
request. A click on it opens that comment.

## Why it exists

GitHub tells you by email. If you check mail twice a day, an approval waits for
hours.

The GitHub app for Slack posts each review in the repo, and it has no filter
for "only mine". `/github subscribe` also refuses to run in a DM with the app,
so you would need a channel just for yourself.

## What it does

A `launchd` agent starts a shell script every 3 minutes. The script asks the
GitHub CLI for each open pull request you take part in:

- **Author** you opened it.
- **Involved** you commented, or were mentioned or assigned.
- **Reviewer** you reviewed it before.
- **Asked** someone requested your review by name.

The script reads the reviews, the comments on the conversation tab and the
inline comments on the diff. It drops your own and the ones it already showed.
Each one left gets a notification:

```
✅ Approved · api-users#570
alice · your PR · 14:32
LGTM
```

- **Title** says what happened: ✅ approved, ⛔️ changes requested, 👀 review
  requested, 📝 review, 💬 comment.
- **Subtitle** names the person, whose pull request it is, and the time in your
  timezone. An event from before today shows the date too: `Sep 15, 18:04`.
- **Click** opens that exact comment, such as `.../pull/42#discussion_r123`.

## What it leaves out

- **Bots** CodeRabbit and Semgrep post dozens of comments and hide the people.
  `GH_REVIEW_NOTIFY_BOTS=1` shows them again.
- **Team requests** GitHub search counts a review asked of your team as
  `review-requested:@me`, and most of the noise comes from there. The script
  checks each hit against `requested_reviewers` and keeps only your own name.
- **The rest** your own comments, closed PRs and CI.

## Bursts and the first run

A reviewer who leaves 10 inline comments at once gives you 1 notification.
Past 4 new comments on one PR they fold into "💬 7 new comments ·
api-users#570", with the names below. An approval or a change request comes on
its own, so a pile of comments can't hide it.

The first run records the last 3 days without a sound, so old events don't
flood the screen. The events already shown are listed in
`~/.cache/gh-review-notify/seen.txt`.

## Install

You need macOS and the [GitHub CLI](https://cli.github.com), logged in. The repo
is private in the `workbench-soft` org, and `gh` fetches the files with your
login.

```sh
/bin/bash -c "$(gh api -H 'Accept: application/vnd.github.raw' repos/workbench-soft/gh-review-notify/contents/install.sh)"
```

1. Homebrew installs `jq` and `terminal-notifier` if they are missing.
2. The script goes into `~/.local/bin`.
3. The agent loads, and it starts again at each login.

To read the code before you run it:

```sh
gh repo clone workbench-soft/gh-review-notify
cd gh-review-notify && ./install.sh
```

The install ends with a test notification. If it doesn't show, switch on
**System Settings > Notifications > terminal-notifier** and run
`gh-review-notify --test`.

## Settings

The installer checks these and writes them into the agent. A value it can't
use stops the install with a message:

```sh
GH_REVIEW_NOTIFY_INTERVAL=60 ./install.sh   # poll every 60 seconds, default 180
GH_REVIEW_NOTIFY_DAYS=7 ./install.sh        # look 7 days back, default 3
GH_REVIEW_NOTIFY_BOTS=1 ./install.sh        # bot comments too, default off
```

The first run reads each pull request you take part in, and it takes a minute.
Later runs open only the PRs whose `updatedAt` moved. A run then takes under 10
seconds and a few API calls out of the 5000 GitHub gives you an hour.

Run the install again to update. A failed download keeps the script you have.

## Uninstall

```sh
gh api -H 'Accept: application/vnd.github.raw' repos/workbench-soft/gh-review-notify/contents/uninstall.sh | bash
```

## No notifications?

```sh
gh-review-notify --status   # agent, account, last run, settings
gh-review-notify --test     # checks the macOS side only
tail ~/Library/Logs/gh-review-notify.log
```

"Could not read your GitHub login" in the log means the Mac was offline or
`gh` lost its login. "GitHub search failed" means a search hit an error or the
rate limit, and the next run tries again.

A user agent runs while you are logged in, and it sleeps with the Mac. On wake
it runs once and catches up.

It works with github.com only. Enterprise hosts are out.

## Development

`tests/run.sh` runs the script against canned GitHub answers in
`tests/fixtures`, and feeds `install.sh` bad settings. Stubs stand in for `gh`, the macOS `date` and
`terminal-notifier`, so it runs on Windows too. It needs `jq`.

```sh
shellcheck -S style gh-review-notify install.sh uninstall.sh tests/run.sh tests/stubs/*
bash tests/run.sh            # compares with tests/expected.txt
bash tests/run.sh --update   # rewrites tests/expected.txt after a change you meant
```

CI runs both on the Windows PC runner.

## Licence

MIT
