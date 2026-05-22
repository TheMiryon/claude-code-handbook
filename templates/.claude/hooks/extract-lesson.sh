#!/usr/bin/env bash
# Hook PostToolUse, nudge to capture a lesson after a significant commit.
# Triggered when a `git commit` was run via Bash. If the commit is significant
# (type feat/fix/refactor, OR ≥ 3 files, OR touches a sensitive zone), prints
# a suggestion on stderr to run `/extract-lesson`.
#
# Anti false-positive: tracks HEAD in .claude/logs/last-extract-head. Silent
# if HEAD didn't actually move (pre-commit hook failure, non-commit bash).
#
# Mute: shares `.claude/coach-mute` flag with coach-suggest.sh.

set -e
cd "$(dirname "$0")/../.."

# ── Shared mute with the Coach ──
[ -f ".claude/coach-mute" ] && exit 0

INPUT="$(cat 2>/dev/null || echo '{}')"
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
[ "$TOOL" != "Bash" ] && exit 0

CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

# Not a git commit → ignore
echo "$CMD" | grep -qE 'git[[:space:]]+commit' || exit 0

# ── Retrieve current HEAD ──
SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "")
[ -z "$SHA" ] && exit 0

# ── Anti false-positive: HEAD must actually have moved ──
LAST_HEAD_FILE=".claude/logs/last-extract-head"
mkdir -p .claude/logs
LAST_HEAD=$(cat "$LAST_HEAD_FILE" 2>/dev/null || echo "")
echo "$SHA" > "$LAST_HEAD_FILE"
[ "$SHA" = "$LAST_HEAD" ] && exit 0

SUBJECT=$(git log -1 --pretty=%s 2>/dev/null || echo "")
[ -z "$SUBJECT" ] && exit 0

# ── Ignore trivial commits ──
echo "$SUBJECT" | grep -qiE '^(merge |revert |wip|tmp)' && exit 0

# ── Significance criteria ──
SIGNIFICANT=0
REASON=""

# Criterion 1: type feat/fix/refactor
if echo "$SUBJECT" | grep -qE '^(feat|fix|refactor)(\([^)]+\))?:'; then
  SIGNIFICANT=1
  REASON="type ${SUBJECT%%:*}"
fi

# Criterion 2: 3+ files
FILES_CHANGED=$(git show --pretty="" --name-only HEAD 2>/dev/null | grep -c . || echo 0)
if [ "$FILES_CHANGED" -ge 3 ]; then
  SIGNIFICANT=1
  REASON="${REASON:+$REASON, }$FILES_CHANGED files"
fi

# Criterion 3: touches a sensitive zone (adapt this regex to your project)
SENSITIVE=$(git show --pretty="" --name-only HEAD 2>/dev/null \
  | grep -E "/(auth|payment|migration|crypto|security)/|\.(sql|migration)$" || true)
if [ -n "$SENSITIVE" ]; then
  SIGNIFICANT=1
  REASON="${REASON:+$REASON, }sensitive zone"
fi

[ "$SIGNIFICANT" -eq 0 ] && exit 0

# ── Output on stderr (colored if TTY) ──
if [ -t 2 ]; then
  C_BORDER="\033[38;5;180m"
  C_TITLE="\033[1;38;5;180m"
  C_HINT="\033[2;38;5;180m"
  C_RESET="\033[0m"
else
  C_BORDER=""; C_TITLE=""; C_HINT=""; C_RESET=""
fi

{
  echo ""
  printf "${C_BORDER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}\n"
  printf "${C_TITLE}  💡 Significant commit (%s), extract a lesson?${C_RESET}\n" "$SHA"
  printf "${C_BORDER}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}\n"
  printf "  %s\n" "$SUBJECT"
  printf "  ${C_HINT}(%s)${C_RESET}\n" "$REASON"
  printf "\n"
  printf "  To make this stick:\n"
  printf "    • /extract-lesson       → adds 1-3 lessons to CLAUDE.md\n"
  printf "    • or ignore if purely mechanical (rename, deps bump, etc.)\n"
  echo ""
} >&2

exit 0
