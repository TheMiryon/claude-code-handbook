#!/usr/bin/env python3
"""PreToolUse guard: block destructive actions before execution.

Cross-platform equivalent of pre-tool-guard.sh (Handbook, Annex L).
Use this one instead of the .sh version when your team is mixed
macOS / Linux / Windows, or when you don't want a `jq` dependency.

Contract, identical to the bash version:
  - the hook payload arrives as JSON on stdin
  - a human-readable reason goes to stderr
  - exit 2 blocks the tool call; exit 0 allows it

Register it in .claude/settings.json:

  "hooks": {
    "PreToolUse": [
      { "hooks": [
          { "type": "command",
            "command": "python3 \"$CLAUDE_PROJECT_DIR/.claude/hooks/pre_tool_guard.py\"" }
      ] }
    ]
  }

Test it without a session (expect exit=2):

  echo '{"tool_name":"Bash","tool_input":{"command":"git push --force"}}' \
    | python3 .claude/hooks/pre_tool_guard.py ; echo "exit=$?"
"""

import json
import re
import sys


def block(msg: str) -> None:
    print(f"BLOCKED: {msg}", file=sys.stderr)
    sys.exit(2)


def main() -> None:
    try:
        data = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        # A guard that crashes is a guard that doesn't guard. Fail open on a
        # malformed payload rather than blocking every tool call in the session.
        sys.exit(0)

    tool = data.get("tool_name", "")
    tool_input = data.get("tool_input") or {}

    # 1. Protect .env files from Write/Edit.
    if tool in ("Edit", "Write", "NotebookEdit"):
        path = tool_input.get("file_path", "") or ""
        if re.search(r"(^|[\\/])\.env(\.|$)", path):
            block(".env file protected. Use provider env vars.")

    # 2. Block destructive shell commands.
    if tool in ("Bash", "PowerShell"):
        cmd = tool_input.get("command", "") or ""

        if re.search(r"rm\s+-[a-zA-Z]*[rf][a-zA-Z]*\s+(/|~|\.\./|\$HOME)", cmd):
            block("rm -rf on a dangerous path.")

        # The Windows spelling of the same mistake.
        if re.search(r"Remove-Item\b.*-Recurse\b.*-Force\b", cmd, re.IGNORECASE):
            block("Remove-Item -Recurse -Force. Confirm explicitly.")

        if re.search(r"git\s+push\b.*(--force\b|\s-f(\s|$))", cmd):
            block("git push --force. Ask the user for explicit confirmation.")

        if re.search(r"git\s+commit\b.*--no-verify\b", cmd):
            block("--no-verify skips the checks. Fix the errors first.")

        if re.search(r"git\s+reset\b.*--hard\b", cmd):
            block("git reset --hard discards work. Confirm explicitly, or use --soft.")

    sys.exit(0)


if __name__ == "__main__":
    main()
