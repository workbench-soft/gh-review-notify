# gh-review-notify moves to workbench-soft as a private repo

## Why

The repo went from `oleg-chibikov` to the `workbench-soft` org, and it is
private now.

- **Install** a raw file on `raw.githubusercontent.com` needs GitHub access, so
  the `curl` install breaks.
- **CI** GitHub's runners charge minutes on a private repo.

## User flows

- **Install** the one-liner fetches `install.sh` with `gh api` and the person's
  login.
- **Uninstall** the same, for `uninstall.sh`.

## Files

- **`install.sh`** outside a clone, `gh api` fetches the script.
  `GH_REVIEW_NOTIFY_SRC` can still point it at another URL.
- **`README.md`** the install, clone and uninstall lines name `workbench-soft`
  and use `gh`.
- **`.github/workflows/shellcheck.yml`** runs on the Mac runner.
- **`CHANGELOG.md`** added, with one entry.

## Steps, in commit order

1. CI moves to the Mac.
2. Install through `gh api`.

## Docs

- `README.md` install and uninstall.
