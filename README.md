# hook-next

## Problem

You want to queue a follow-up task for Claude Code while it's mid-turn, without interrupting its current work and without burning an extra LLM call on the queueing itself.
<img width="518" height="106" alt="image" src="https://github.com/user-attachments/assets/e8e05ca3-ec7f-49bb-a420-d6571ea1c069" />

*TLDR: Enter comand -> press enter, comand start working after next tool call, not when calude finish current task
Codex have 'Tab' comand, but claude code dont.*

## How it works

`qnext "text"` writes the text to `/tmp/claude-next-<session_id>.txt`, deriving `session_id` from the most-recent `.jsonl` in `~/.claude/projects/<cwd-encoded>/`. A `Stop` hook reads that file when Claude's turn ends and emits `{"decision":"block","reason":"<text>"}`, which Claude Code treats as the next instruction.

## Install

```sh
git clone git@github.com:freQuensy23-coder/hook-next.git ~/PycharmProjects/hook-next
chmod +x ~/PycharmProjects/hook-next/{bin/qnext,hooks/feed_next.sh}
ln -sf ~/PycharmProjects/hook-next/bin/qnext ~/.local/bin/qnext
```

Merge `settings.example.json` into `~/.claude/settings.json`, start a new Claude Code session. Needs `bash`, `jq`.
