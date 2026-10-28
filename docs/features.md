# Features

## Review and comment notifications

A notification shows each review and comment another person leaves on your
open PRs. It appears in macOS Notification Center within 3 minutes.

- **Where** Notification Center. A click opens the comment.
- **Limits** github.com only. Open PRs updated in the last 3 days, 100 per
  search.

## Review requests

A notification shows when someone asks you by name to review a PR.

- **Where** Notification Center, with the 👀 badge.
- **Limits** a request sent to one of your teams stays silent.

## Comment bursts

More than 4 new comments on one PR in a run come as 1 notification with the
count and the names. Approvals and change requests still come one by one.

- **Where** Notification Center. A click opens the PR.

## Quiet first run

The first run records the last 3 days of events and shows none of them. A first
run that fails records nothing, so the next run seeds again.

- **Where** the install prints "Seeded N past events".

## Bot filter

Comments by bot accounts stay silent.

- **Where** `GH_REVIEW_NOTIFY_BOTS=1 ./install.sh` turns them on.

## Status and test

- **`--status`** prints the agent state, the account, the last run, the
  settings and the log path.
- **`--test`** sends a test notification.
