# macOS notifications for reviews and comments on my PRs

Done on 2025-09-16, before the history was reset to one commit. The old commits sit under `refs/backup/main` in the local backup mirror of `gh-review-notify`.

## Why

Reviews and comments on my pull requests got lost in GitHub email. A desktop notification shows them the moment they land.

## User flows it touches

- **Review lands** a notification shows who approved or asked for changes, with an emoji badge.
- **Comment burst** several comments from one person come in as one notification.
- **Status** `--status` shows what the tool last checked.

## Changes

- **`gh-review-notify`** new.
- **`install.sh`** new.
- **`LICENSE`** new.
- **`uninstall.sh`** new.
- **`.github/workflows/shellcheck.yml`** new.

## Steps, in commit order

1. macOS notifications for reviews and comments on your PRs (4fa80b3, 2025-09-16)
2. Skip bots, group comment bursts, and re-read only the PRs that changed (c150d69, 2025-09-16)
3. Shorten the README (3a66012, 2025-09-16)
4. Raise the search limit, keep failed lookups out of the cache, add --status (d75a557, 2025-09-16)
5. Add emoji badges, subtitle byline, and split approvals/changes from comment bursts (47b9ae7, 2025-09-16)

## Docs to update

- `README.md`
