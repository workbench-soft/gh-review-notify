# Move gh-review-notify to workbench-soft and make it private

## Why

The repo moved from `oleg-chibikov` to the `workbench-soft` org and is private now.
Raw files on `raw.githubusercontent.com` need GitHub access, so the `curl` install fails.
GitHub's runners bill minutes on a private repo.

## User flows it touches

- **Install** the one-liner fetches `install.sh` through `gh api` with the person's login.
- **Uninstall** the same, for `uninstall.sh`.

## Changes

- **`install.sh`** outside a clone, fetches the script through `gh api`. `GH_REVIEW_NOTIFY_SRC` still points it at another URL.
- **`README.md`** install, clone and uninstall lines name `workbench-soft` and use `gh`.
- **`.github/workflows/shellcheck.yml`** runs on the Mac runner.
- **`CHANGELOG.md`** new, with one entry.

## Steps, in commit order

1. Move CI to the Mac.
2. Install through `gh api`.

## Docs to update

- `README.md` install and uninstall.
