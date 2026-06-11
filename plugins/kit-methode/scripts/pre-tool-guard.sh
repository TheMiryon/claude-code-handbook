#!/usr/bin/env bash
# Hook PreToolUse, Defensive guards against common destructive mistakes.
# Blocks before execution (exit code 2 = blocked) rather than warning after.
# Cf. chapter 3 of the Claude Code Handbook.

INPUT="$(cat 2>/dev/null || echo '{}')"
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")

# 1. Block any Edit/Write to .env files
if [ "$TOOL" = "Edit" ] || [ "$TOOL" = "Write" ]; then
  FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || echo "")
  case "$FILE" in
    *.env|*.env.*|.env)
      echo "BLOCKED: .env files are protected. Use your deploy provider's env vars (prod) or .env.local (dev local)." >&2
      exit 2
      ;;
  esac
fi

# 2. Block dangerous Bash commands
if [ "$TOOL" = "Bash" ]; then
  CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

  # rm -rf on dangerous roots: bare / (e.g. "rm -rf /", "rm -rf /*"), ~, ../, $HOME.
  # A specific absolute path like /tmp/x is allowed (only the bare root matches).
  if echo "$CMD" | grep -qE 'rm[[:space:]]+-[a-zA-Z]*[rf][a-zA-Z]*[[:space:]]+(/([[:space:]]|$|\*)|~|\.\./|\$HOME)' ; then
    echo "BLOCKED: rm -rf on a dangerous path. Use an explicit, precise path." >&2
    exit 2
  fi

  # git push --force / --force-with-lease / -f
  if echo "$CMD" | grep -qE 'git[[:space:]]+push.*(--force|--force-with-lease|[[:space:]]-f([[:space:]]|$))' ; then
    echo "BLOCKED: git push --force detected. If really intended, ask the user for explicit confirmation first." >&2
    exit 2
  fi

  # git commit --no-verify (skips pre-commit hooks like husky)
  if echo "$CMD" | grep -qE 'git[[:space:]]+commit.*--no-verify' ; then
    echo "BLOCKED: --no-verify skips your pre-commit hook. Fix the underlying errors instead." >&2
    exit 2
  fi

  # git reset --hard with HEAD~ or origin/ (warn only, don't block, sometimes legitimate)
  if echo "$CMD" | grep -qE 'git[[:space:]]+reset[[:space:]]+--hard[[:space:]]+(HEAD~|HEAD\^|origin/)' ; then
    echo "WARN: git reset --hard detected, possible commit loss. Verify nothing is unstashed first." >&2
    # Not exit 2: just warn the user.
  fi
fi

exit 0
