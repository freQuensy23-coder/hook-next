#!/usr/bin/env bash
# Stop hook: when Claude ends a turn, check for a queued follow-up for
# this session and, if present, feed it back as the next instruction
# via the {decision:"block",reason:...} JSON protocol.
set -euo pipefail

input=$(cat)
sid=$(printf '%s' "$input" | jq -r .session_id)
f="/tmp/claude-next-$sid.txt"

if [ -s "$f" ]; then
    msg=$(cat "$f")
    rm -f "$f"
    jq -n --arg r "$msg" '{decision:"block",reason:$r}'
fi
