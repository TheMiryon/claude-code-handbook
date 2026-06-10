#!/usr/bin/env bash
# Hook PostToolUse, format a written file via the configured FORMAT_CMD.
# No-op unless `format_cmd` is set in the plugin's userConfig (we never guess a
# formatter). Non-blocking: a missing or failing formatter exits clean.
# Plugin form: operates on the consuming project via ${CLAUDE_PROJECT_DIR}.

set -e
cd "${CLAUDE_PROJECT_DIR}" 2>/dev/null || exit 0
. "${CLAUDE_PLUGIN_ROOT}/scripts/kit-env.sh" 2>/dev/null || exit 0

# No formatter configured → nothing to do.
[ -z "$KIT_FORMAT_CMD" ] && exit 0

INPUT="$(cat 2>/dev/null || echo '{}')"
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || true)

# No file, or file gone (deleted, dry run) → exit
[ -z "$FILE" ] && exit 0
[ ! -f "$FILE" ] && exit 0

# Skip build outputs, dependencies, migrations
case "$FILE" in
  *node_modules*|*.next/*|*build/*|*dist/*|*/migrations/*) exit 0 ;;
esac

# Run the user's formatter with the file path appended as an argument.
# (Which extensions to handle is the formatter's responsibility, not ours.)
sh -c "$KIT_FORMAT_CMD \"\$1\"" _ "$FILE" >/dev/null 2>&1 || true

exit 0
