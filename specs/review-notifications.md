# macOS notifications for reviews and comments on my PRs

Finished on 2025-09-16, before the history was squashed to one commit. The old
commits are under `refs/backup/main` in the local backup mirror of
`gh-review-notify`.

## Why

GitHub email buried the reviews and comments on my pull requests. A desktop
notification shows each one as it arrives.

## User flows

- **A review lands** the notification names who approved or asked for changes,
  with an emoji badge.
- **A comment burst** many comments from one person come as 1 notification.
- **Status** `--status` tells what the tool checked last.

## Files

- **`gh-review-notify`** added.
- **`install.sh`** added.
- **`uninstall.sh`** added.
- **`LICENSE`** added.
- **`.github/workflows/shellcheck.yml`** added.

## Steps, in commit order

1. macOS notifications for reviews and comments on your PRs (4fa80b3, 2025-09-16)
2. Skip bots, fold comment bursts, re-read only the PRs that changed (c150d69, 2025-09-16)
3. Shorter README (3a66012, 2025-09-16)
4. Higher search limit, failed lookups kept out of the cache, `--status` (d75a557, 2025-09-16)
5. Emoji badges, a subtitle byline, approvals and change requests apart from comment bursts (47b9ae7, 2025-09-16)

## Docs

- `README.md`
