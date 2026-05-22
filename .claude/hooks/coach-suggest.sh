#!/usr/bin/env bash
# Hook Stop — Coach mode.
# Analyzes the activity log of the just-finished session and suggests the next
# relevant command/agent based on what was touched. Zero-token (local script),
# zero friction (output to stderr → visible in terminal).
# Reads .claude/logs/activity.log (populated by activity-log.sh).
#
# Customize the triggers in the section below to match YOUR project patterns.

set -e
cd "$(dirname "$0")/../.."

# Coach mute: if .claude/coach-mute flag exists, exit silently.
# Toggle with /coach-mute and /coach-on slash commands, or manually:
#   touch .claude/coach-mute   (mute)
#   rm   .claude/coach-mute    (unmute)
[ -f ".claude/coach-mute" ] && exit 0

LOG_DIR=".claude/logs"
LOG="$LOG_DIR/activity.log"
[ ! -f "$LOG" ] && exit 0

INPUT="$(cat 2>/dev/null || echo '{}')"
SID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null | cut -c1-8)
[ -z "$SID" ] && exit 0

# Last 200 lines of THIS session only
RECENT=$(grep "\[$SID\]" "$LOG" 2>/dev/null | tail -200)
[ -z "$RECENT" ] && exit 0

# Files touched (WRITE | EDIT) — unique
FILES=$(echo "$RECENT" | grep -E 'WRITE  \||EDIT   \|' | sed 's/.*| //' | sort -u)
WRITES=$(echo "$RECENT" | grep -cE 'WRITE  \||EDIT   \|' || true)

# No write activity → nothing to suggest (Claude only read/answered)
[ "$WRITES" -eq 0 ] && exit 0

SUGGESTIONS=""

# ────────────────────────────────────────────────────────────────
# CUSTOMIZE THE TRIGGERS BELOW TO MATCH YOUR PROJECT
# Each trigger is a pattern match + a suggestion string.
# ────────────────────────────────────────────────────────────────

# Example trigger 1: UI component touched → suggest a polish review
# UI_TOUCHED=$(echo "$FILES" | grep "components/" || true)
# if [ -n "$UI_TOUCHED" ]; then
#   W_FILE=$(echo "$UI_TOUCHED" | head -1)
#   SUGGESTIONS="${SUGGESTIONS}  • /loro $W_FILE\n      → polish the modified component\n"
# fi

# Example trigger 2: server actions / auth / API → suggest security audit
SECU=$(echo "$FILES" | grep -E "actions\.ts|/auth/|/api/|register|login|reset-password" || true)
if [ -n "$SECU" ]; then
  SUGGESTIONS="${SUGGESTIONS}  • Agent security-auditor\n      → check auth/RLS/secrets on touched routes\n"
fi

# Example trigger 3: DB migrations → suggest schema reviewer
MIGS=$(echo "$FILES" | grep -E "migrations/|\.sql$" || true)
if [ -n "$MIGS" ]; then
  SUGGESTIONS="${SUGGESTIONS}  • Agent db-schema-reviewer\n      → indices, FK, RLS policies on the migration\n"
fi

# Trigger: many files touched → suggest /audit-quick
FCOUNT=$(echo "$FILES" | grep -c . 2>/dev/null || echo 0)
if [ "$FCOUNT" -ge 10 ]; then
  SUGGESTIONS="${SUGGESTIONS}  • /audit-quick\n      → $FCOUNT files touched, code + security audit recommended\n"
fi

# Trigger: any meaningful write → suggest /ship
if [ "$WRITES" -ge 2 ]; then
  SUGGESTIONS="${SUGGESTIONS}  • /ship \"<type(scope): message>\"\n      → when ready to push (verify + commit + push)\n"
fi

# Nothing to suggest → exit silently
[ -z "$SUGGESTIONS" ] && exit 0

# Colored output (ANSI) if TTY, plain otherwise
if [ -t 2 ]; then
  C_BORDER="\033[38;5;180m"  # pale gold
  C_TITLE="\033[1;38;5;180m"
  C_RESET="\033[0m"
else
  C_BORDER=""
  C_TITLE=""
  C_RESET=""
fi

{
  echo ""
  printf "${C_BORDER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}\n"
  printf "${C_TITLE}  Coach · suggestions after this session ($SID)${C_RESET}\n"
  printf "${C_BORDER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}\n"
  printf "%b" "$SUGGESTIONS"
  echo ""
} >&2

exit 0
