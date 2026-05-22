#!/usr/bin/env bash
# Hook PostToolUse, Lightweight zero-token log of Claude Code activity.
# Logs: Write, Edit, Bash (commands truncated to 200 chars), sub-agent invocations.
# Output: .claude/logs/activity.log (gitignored).
# Self-rotating: keeps last 3000 lines once log exceeds 5000.

set -e
cd "$(dirname "$0")/../.."

INPUT="$(cat 2>/dev/null || echo '{}')"
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
[ -z "$TOOL" ] && exit 0

LOG_DIR=".claude/logs"
LOG_FILE="$LOG_DIR/activity.log"
mkdir -p "$LOG_DIR"

TS=$(date '+%Y-%m-%d %H:%M:%S')
SID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null | cut -c1-8)
[ -z "$SID" ] && SID="--------"

case "$TOOL" in
  Bash)
    CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null | tr '\n' ' ' | cut -c1-200)
    echo "[$TS] [$SID] BASH   | $CMD" >> "$LOG_FILE"
    ;;
  Write)
    FP=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
    echo "[$TS] [$SID] WRITE  | $FP" >> "$LOG_FILE"
    ;;
  Edit)
    FP=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null)
    echo "[$TS] [$SID] EDIT   | $FP" >> "$LOG_FILE"
    ;;
  Agent|Task)
    # Sub-agent invocation, log the agent type to track which agents are actually used
    SUB=$(echo "$INPUT" | jq -r '.tool_input.subagent_type // .tool_input.description // empty' 2>/dev/null | cut -c1-80)
    echo "[$TS] [$SID] AGENT  | $SUB" >> "$LOG_FILE"
    ;;
esac

# Rotation: if > 5000 lines, keep the last 3000
LINES=$(wc -l < "$LOG_FILE" 2>/dev/null || echo 0)
if [ "$LINES" -gt 5000 ]; then
  tail -3000 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
fi

exit 0
