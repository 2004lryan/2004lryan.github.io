#!/usr/bin/env bash
# Sync local edits to https://github.com/2004lryan/2004lryan.github.io
# Usage: ./sync.sh                  (auto commit message with date)
#        ./sync.sh "your message"   (custom commit message)
set -euo pipefail

cd "$(dirname "$0")"

dirty=$(git status --porcelain)
unpushed=$(git log origin/main..HEAD --oneline 2>/dev/null || echo "")

if [ -z "$dirty" ] && [ -z "$unpushed" ]; then
  echo "No changes to sync."
  exit 0
fi

if [ -n "$dirty" ]; then
  git add -A
  msg="${1:-update $(date '+%Y-%m-%d %H:%M')}"
  git commit -m "$msg"
else
  echo "Working tree clean; pushing $(echo "$unpushed" | wc -l | tr -d ' ') already-committed change(s)."
fi

git push origin main
echo "Synced."
echo "Live at: https://2004lryan.github.io (rebuild ~30s)"
