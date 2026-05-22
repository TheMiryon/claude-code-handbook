#!/usr/bin/env bash
# Hook PostToolUse, Auto-format files after Write/Edit.
# Adapt the formatter command to your stack. Default below: ESLint --fix for JS/TS.
#
# Other formatters you might use:
#   - prettier --write "$FILE"     (JS/TS/CSS/MD)
#   - black --quiet "$FILE"        (Python)
#   - ruff format "$FILE"          (Python, faster)
#   - gofmt -w "$FILE"             (Go)
#   - rustfmt "$FILE"              (Rust)
#   - swiftformat "$FILE"          (Swift)
#
# If the formatter is missing or fails, exit clean (no blocking).

set -e

INPUT="$(cat 2>/dev/null || echo '{}')"
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || true)

# No file → exit silently
[ -z "$FILE" ] && exit 0

# File doesn't exist (deleted, dry run) → exit
[ ! -f "$FILE" ] && exit 0

# Only handle JS/TS/JSX/TSX/MJS, adapt for your stack
case "$FILE" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs) ;;
  *) exit 0 ;;
esac

# Skip build outputs, dependencies, migrations
case "$FILE" in
  *node_modules*|*.next/*|*build/*|*dist/*|*supabase/migrations/*) exit 0 ;;
esac

cd "$(dirname "$0")/../.."

# Run formatter, silent, non-blocking
# Pick ONE of these depending on your project:
pnpm exec eslint --fix "$FILE" >/dev/null 2>&1 || true
# npx prettier --write "$FILE" >/dev/null 2>&1 || true
# pnpm exec biome format --write "$FILE" >/dev/null 2>&1 || true

exit 0
