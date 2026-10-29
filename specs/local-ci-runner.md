# CI runs on the dev machine that is on, Mac or Windows

## Why

Development moved to Windows. CI asked for the Mac runner by name, and it
waited whenever the Mac was off.

## User flows

- **Pull request and push** the jobs run on the Windows PC or the Mac, whichever
  is online.

## Files

- **`.github/workflows/`** the jobs ask for `[self-hosted, local]` and run their
  steps in bash. If shellcheck is missing, brew installs it on the Mac and
  winget on Windows.
- **`CHANGELOG.md`** one entry.

## Steps, in commit order

1. This plan and the workflow change.

## Docs

- `CHANGELOG.md`

## Update 2025-10-29: a newer push cancels the older runs

- **Why** the one local runner spent its time on checks and deploys of commits a newer push already replaced.
- **Workflows** each workflow a push starts sets `cancel-in-progress: true` in its concurrency group, keyed on the branch or the PR, so a newer push stops the older run.
