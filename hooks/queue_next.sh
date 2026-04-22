#!/usr/bin/env bash
# UserPromptSubmit hook: intercept prompts starting with "next: " and
# queue the text for the Stop hook to feed back after the next turn.
# Never invokes the LLM.
set -euo pipefail

input=$(cat)
sid=$(printf '%s' "$input" | jq -r .session_id)
prompt=$(printf '%s' "$input" | jq -r .prompt)

case "$prompt" in
    "next: "*)
        msg="${prompt#next: }"
        printf '%s' "$msg" > "/tmp/claude-next-$sid.txt"
        printf 'Queued for next turn: %s\n' "$msg" >&2
        exit 2
        ;;
esac
