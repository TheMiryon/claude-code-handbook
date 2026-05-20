#!/usr/bin/env bash
# Hook SessionStart — Show a quick project status at session open.
# Read-only, no destructive actions.

set -e
cd "$(dirname "$0")/../.."

# 1. Silent fetch to detect remote drift
git fetch origin --quiet 2>/dev/null || true

# 2. Current branch + working tree state
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "?")
DIRTY=$(git status --porcelain 2>/dev/null | wc -l | xargs)

# 3. Ahead / behind upstream
AHEAD=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "?")
BEHIND=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "?")

# 4. Header
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  $(basename "$PWD") · session started · $(date '+%a %d %b %Hh%M')"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 5. Git state
echo "  Branch       : $BRANCH"
if [ "$DIRTY" = "0" ]; then
  echo "  Working tree : clean"
else
  echo "  Working tree : $DIRTY file(s) modified (uncommitted)"
fi

if [ "$AHEAD" != "0" ] && [ "$AHEAD" != "?" ]; then
  echo "  ⚠  $AHEAD unpushed commit(s)"
fi
if [ "$BEHIND" != "0" ] && [ "$BEHIND" != "?" ]; then
  echo "  ⚠  $BEHIND commit(s) behind upstream — git pull"
fi

# 6. Last 3 commits
echo ""
echo "  Last commits:"
git log --oneline -3 2>/dev/null | sed 's/^/    /'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
