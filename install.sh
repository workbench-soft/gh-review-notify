#!/bin/bash
# Installs gh-review-notify into ~/.local/bin and loads a launchd agent that runs
# it every few minutes and again at each login.
set -euo pipefail

# The repo is private, so outside a clone the files come through gh with your login.
github_repo=workbench-soft/gh-review-notify
source_url=${GH_REVIEW_NOTIFY_SRC:-}
agent_label=io.github.gh-review-notify
poll_seconds=${GH_REVIEW_NOTIFY_INTERVAL:-180}
lookback_days=${GH_REVIEW_NOTIFY_DAYS:-3}
show_bots=${GH_REVIEW_NOTIFY_BOTS:-0}
bin_dir="$HOME/.local/bin"
installed_script="$bin_dir/gh-review-notify"
agent_plist="$HOME/Library/LaunchAgents/$agent_label.plist"
log_file="$HOME/Library/Logs/gh-review-notify.log"

fail() { echo "$1" >&2; exit 1; }

check_requirements() {
  [ "$(uname)" = "Darwin" ] || fail "macOS only."
  command -v gh > /dev/null || fail "Install the GitHub CLI first: brew install gh"
  gh auth status > /dev/null 2>&1 || fail "Log in first: gh auth login"
  command -v brew > /dev/null || fail "Homebrew is missing: see https://brew.sh"
}

brew_install_missing() { # command name
  command -v "$1" > /dev/null && return
  echo "Installing $1..."
  brew install "$1"
}

# macOS shows no notification from terminal-notifier until LaunchServices knows the app.
register_notifier_app() {
  local app
  app="$(brew --prefix terminal-notifier 2> /dev/null)/terminal-notifier.app"
  [ -d "$app" ] || return 0
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$app"
  open -g "$app" --args -title "gh-review-notify" -message "Installing" > /dev/null 2>&1 || true
}

# Takes the script from the clone beside this file, from GH_REVIEW_NOTIFY_SRC, or from GitHub.
# The agent of an earlier install can start at any moment, so the new script
# replaces the old one in a single rename, and a failed download leaves it be.
copy_script() {
  local clone_dir new_script="$installed_script.new"
  mkdir -p "$bin_dir"
  clone_dir=$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2> /dev/null && pwd || echo .)
  if [ -f "$clone_dir/gh-review-notify" ]; then
    cp "$clone_dir/gh-review-notify" "$new_script"
  elif [ -n "$source_url" ]; then
    curl -fsSL "$source_url/gh-review-notify" -o "$new_script"
  else
    gh api -H 'Accept: application/vnd.github.raw' "repos/$github_repo/contents/gh-review-notify" > "$new_script"
  fi
  head -n 1 "$new_script" | grep -qx '#!/bin/bash' || fail "The download of gh-review-notify is not the script. Try again."
  chmod +x "$new_script"
  mv "$new_script" "$installed_script"
}

write_agent_plist() {
  mkdir -p "$HOME/Library/LaunchAgents"
  cat > "$agent_plist" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>$agent_label</string>
	<key>ProgramArguments</key>
	<array>
		<string>$installed_script</string>
	</array>
	<key>StartInterval</key>
	<integer>$poll_seconds</integer>
	<key>EnvironmentVariables</key>
	<dict>
		<key>GH_REVIEW_NOTIFY_DAYS</key>
		<string>$lookback_days</string>
		<key>GH_REVIEW_NOTIFY_BOTS</key>
		<string>$show_bots</string>
	</dict>
	<key>RunAtLoad</key>
	<true/>
	<key>StandardOutPath</key>
	<string>$log_file</string>
	<key>StandardErrorPath</key>
	<string>$log_file</string>
</dict>
</plist>
PLIST
}

load_agent() {
  launchctl bootout "gui/$(id -u)/$agent_label" 2> /dev/null || true
  launchctl bootstrap "gui/$(id -u)" "$agent_plist"
}

print_summary() {
  cat << TEXT

Installed.
  script   $installed_script
  agent    $agent_plist, every ${poll_seconds}s, starts again at login
  log      $log_file

A test notification should be on screen. If it is missing, switch on
System Settings > Notifications > terminal-notifier, then run:
  gh-review-notify --test
TEXT
}

check_requirements
brew_install_missing jq
brew_install_missing terminal-notifier
register_notifier_app
copy_script
write_agent_plist

echo "Reading your pull requests..."
"$installed_script" || fail "The first run failed. See $log_file"

load_agent
"$installed_script" --test
print_summary
