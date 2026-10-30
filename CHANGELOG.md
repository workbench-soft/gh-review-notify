# Changelog

## Unreleased

- **Search errors** a failed GitHub search stops the run and keeps the caches. A first install during an outage no longer floods the next run with 3 days of old events.
- **CI** runs on pushes to main only. PR runs are off, and the workflow says how to turn them back on.
- **CI** a newer push to main or to a PR cancels the checks and deploys still running for the older commit.
