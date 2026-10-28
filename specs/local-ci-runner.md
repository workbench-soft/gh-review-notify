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
