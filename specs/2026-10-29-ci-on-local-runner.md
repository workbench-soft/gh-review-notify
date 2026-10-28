# Run CI on whichever dev machine is on, Mac or Windows

## Why

Development moved to Windows. CI asked for the Mac runner by name and waited while the Mac was off.

## User flows it touches

- **Pull request and push** the jobs run on the Windows PC or the Mac, whichever is online.

## Changes

- **`.github/workflows/`** jobs ask for `[self-hosted, local]` and run their steps in bash. A missing shellcheck installs through brew on the Mac and winget on Windows.
- **`CHANGELOG.md`** one entry.

## Steps, in commit order

1. This plan and the workflow changes.

## Docs to update

- `CHANGELOG.md`
