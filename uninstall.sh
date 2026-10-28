#!/bin/bash
# Stops the launchd agent and deletes everything install.sh put on the Mac.
set -uo pipefail

agent_label=io.github.gh-review-notify

launchctl bootout "gui/$(id -u)/$agent_label" 2> /dev/null
rm -f "$HOME/Library/LaunchAgents/$agent_label.plist"
rm -f "$HOME/.local/bin/gh-review-notify"
rm -rf "${XDG_CACHE_HOME:-$HOME/.cache}/gh-review-notify"
rm -f "$HOME/Library/Logs/gh-review-notify.log"

echo "Removed. terminal-notifier and jq are still installed: brew uninstall them if you want."
