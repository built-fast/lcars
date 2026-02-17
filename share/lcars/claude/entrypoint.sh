#!/bin/sh
set -e

# Write OAuth token to the plaintext credential store that Claude Code
# falls back to when no system keychain is available (i.e., in Docker).
if [ -n "$CLAUDE_CODE_OAUTH_TOKEN" ]; then
  mkdir -p "$HOME/.claude"
  printf '%s' "$CLAUDE_CODE_OAUTH_TOKEN" > "$HOME/.claude/.credentials.json"
  chmod 600 "$HOME/.claude/.credentials.json"
  unset CLAUDE_CODE_OAUTH_TOKEN
fi

exec claude "$@"
