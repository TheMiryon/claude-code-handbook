#!/usr/bin/env bash
# Sourced helper for kit-methode hooks.
# Resolves per-project configuration from the plugin's userConfig
# (exported as CLAUDE_PLUGIN_OPTION_* env vars) with lockfile auto-detection.
#
# MUST stay safe under a caller's `set -e`: every statement here succeeds
# (only `[ -f … ]` tests inside `if` conditions, all branches assign a value),
# so sourcing this file never aborts the parent script.
#
# Caller contract: `cd` into "${CLAUDE_PROJECT_DIR}" BEFORE sourcing this file
# (lockfile detection is relative to the current directory).
#
# Exports: KIT_PM KIT_TEST_CMD KIT_FORMAT_CMD KIT_TEST_PATHS KIT_TEST_GATE_BLOCK

# 1. Package manager: explicit override → lockfile detection → empty
KIT_PM="${CLAUDE_PLUGIN_OPTION_PACKAGE_MANAGER:-}"
if [ -z "$KIT_PM" ]; then
  if   [ -f pnpm-lock.yaml ];    then KIT_PM="pnpm"
  elif [ -f yarn.lock ];         then KIT_PM="yarn"
  elif [ -f bun.lockb ];         then KIT_PM="bun"
  elif [ -f package-lock.json ]; then KIT_PM="npm"
  else                                KIT_PM=""
  fi
fi

# 2. Test command: explicit → "<pm> test" → empty (gate disabled)
KIT_TEST_CMD="${CLAUDE_PLUGIN_OPTION_TEST_CMD:-}"
if [ -z "$KIT_TEST_CMD" ] && [ -n "$KIT_PM" ]; then
  KIT_TEST_CMD="$KIT_PM test"
fi

# 3. Format command: explicit only, never guessed
KIT_FORMAT_CMD="${CLAUDE_PLUGIN_OPTION_FORMAT_CMD:-}"

# 4. Test path filter: space/comma-separated, matched as substrings
KIT_TEST_PATHS="${CLAUDE_PLUGIN_OPTION_TEST_PATHS:-}"

# 5. Blocking gate? default warn-only
KIT_TEST_GATE_BLOCK="${CLAUDE_PLUGIN_OPTION_TEST_GATE_BLOCK:-false}"

export KIT_PM KIT_TEST_CMD KIT_FORMAT_CMD KIT_TEST_PATHS KIT_TEST_GATE_BLOCK
