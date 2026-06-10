#!/usr/bin/env bash
# Hook Stop, run the project's tests at end of turn (a gate).
#
# Fires ONLY when ALL of these hold:
#   - the Coach is not muted (.claude/coach-mute absent),
#   - a test command is resolvable (userConfig test_cmd, or "<detected pm> test"),
#   - this session performed ≥1 write/edit (never on read-only / answer-only turns),
#   - if test_paths is set: a written file matches one of those paths.
#
# Warn-only by default (prints failures to stderr). Blocks the turn (exit 2)
# only when test_gate_block=true.
# Plugin form: operates on the consuming project via ${CLAUDE_PROJECT_DIR}.

set -e
cd "${CLAUDE_PROJECT_DIR}" 2>/dev/null || exit 0
. "${CLAUDE_PLUGIN_ROOT}/scripts/kit-env.sh" 2>/dev/null || exit 0

# Mute shared with the Coach
[ -f ".claude/coach-mute" ] && exit 0

# No test command resolvable → nothing to gate
[ -z "$KIT_TEST_CMD" ] && exit 0

LOG=".claude/logs/activity.log"
[ ! -f "$LOG" ] && exit 0

INPUT="$(cat 2>/dev/null || echo '{}')"
SID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null | cut -c1-8)
[ -z "$SID" ] && exit 0

RECENT=$(grep "\[$SID\]" "$LOG" 2>/dev/null | tail -200 || true)
[ -z "$RECENT" ] && exit 0

# Unconditional guard: at least one write/edit this session.
FILES=$(echo "$RECENT" | grep -E 'WRITE  \||EDIT   \|' | sed 's/.*| //' | sort -u || true)
[ -z "$FILES" ] && exit 0

# Optional path filter: only gate if a written file matches one of test_paths.
if [ -n "$KIT_TEST_PATHS" ]; then
  PATHS_NORM="${KIT_TEST_PATHS//,/ }"
  MATCH=""
  for p in $PATHS_NORM; do
    [ -z "$p" ] && continue
    if echo "$FILES" | grep -qF "$p"; then MATCH=1; break; fi
  done
  [ -z "$MATCH" ] && exit 0
fi

# ── Run the test command ──
{
  echo ""
  printf "  ⏳ kit-methode test-gate: %s\n" "$KIT_TEST_CMD"
} >&2

if OUTPUT=$(sh -c "$KIT_TEST_CMD" 2>&1); then
  printf "  ✅ kit-methode test-gate: tests passed\n\n" >&2
  exit 0
fi

# ── Tests failed ──
{
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  ❌ kit-methode test-gate: tests FAILED ($KIT_TEST_CMD)"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "$OUTPUT" | tail -30
  echo ""
  if [ "$KIT_TEST_GATE_BLOCK" = "true" ]; then
    echo "  (test_gate_block is on → blocking. Fix the tests, or /coach-mute to bypass.)"
  else
    echo "  (warn-only. Set test_gate_block=true to make this blocking.)"
  fi
  echo ""
} >&2

if [ "$KIT_TEST_GATE_BLOCK" = "true" ]; then
  exit 2
fi
exit 0
