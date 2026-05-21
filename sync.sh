#!/usr/bin/env bash
# Sync local edits to https://github.com/2004lryan/2004lryan.github.io
# Usage: ./sync.sh                  (auto commit message with date)
#        ./sync.sh "your message"   (custom commit message)
set -euo pipefail

cd "$(dirname "$0")"

if [ -z "$(git status --porcelain)" ]; then
  echo "No changes to sync."
  exit 0
fi

git add -A
msg="${1:-update $(date '+%Y-%m-%d %H:%M')}"
git commit -m "$msg"
git push origin main
echo "Synced: $msg"
echo "Live at: https://2004lryan.github.io (rebuild ~30s)"
