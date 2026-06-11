#!/usr/bin/env bash
# Hook UserPromptSubmit, reinject the OPERATING-CONTRACT into context each turn.
#
# Emits hookSpecificOutput.additionalContext as JSON on stdout — REQUIRED for
# UserPromptSubmit (plain stdout would reach only the debug log, not Claude).
#
# Source resolution: the project's .claude/OPERATING-CONTRACT.md overrides the
# bundled generic rules 1-5. Uses ABSOLUTE paths (no cd, does not source kit-env).
#
# Degrades to NO output (exit 0) on any failure — never a malformed JSON, never
# an empty additionalContext.

# Toggle (house idiom: default on, test positively)
INJECT="${CLAUDE_PLUGIN_OPTION_INJECT_CONTRACT:-true}"
[ "$INJECT" = "true" ] || exit 0

# jq is required to build safe JSON; without it, inject nothing.
command -v jq >/dev/null 2>&1 || exit 0

# Resolve source: project contract overrides the bundled template.
PROJECT_CONTRACT="${CLAUDE_PROJECT_DIR}/.claude/OPERATING-CONTRACT.md"
BUNDLED_CONTRACT="${CLAUDE_PLUGIN_ROOT}/templates/operating-contract.md"
if   [ -r "$PROJECT_CONTRACT" ] && [ -s "$PROJECT_CONTRACT" ]; then FILE="$PROJECT_CONTRACT"
elif [ -r "$BUNDLED_CONTRACT" ] && [ -s "$BUNDLED_CONTRACT" ]; then FILE="$BUNDLED_CONTRACT"
else exit 0
fi

# Build JSON safely: jq -Rs slurps the whole file into one escaped string.
jq -Rs '{hookSpecificOutput: {hookEventName: "UserPromptSubmit", additionalContext: .}}' < "$FILE" 2>/dev/null || exit 0

exit 0
