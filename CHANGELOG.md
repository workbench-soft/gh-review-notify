# Changelog

## Unreleased

- **Review requests** a failed reviewer lookup is asked again on the next run. Before, the request counted as a team request and stayed silent.
- **Search errors** a failed GitHub search stops the run and keeps the caches. A first install during an outage no longer floods the next run with 3 days of old events.
- **CI** runs on pushes to main only. PR runs are off, and the workflow says how to turn them back on.
- **CI** a newer push to main or to a PR cancels the checks and deploys still running for the older commit.
