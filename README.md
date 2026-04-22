# hook-next

Queue a follow-up prompt for Claude Code that auto-fires when the current turn ends. Zero extra LLM calls for the queueing step.

## What it does

While Claude is mid-turn, type:

```
next: run the tests after you finish
```

The text is stashed to `/tmp/claude-next-<session_id>.txt` and the prompt is blocked from ever reaching the model. When Claude finishes its current turn, a `Stop` hook reads the file and feeds the queued text back as the next instruction.

Result: you get a simple "task queue" built entirely out of Claude Code hooks, with per-session isolation.

## How it works

Two hooks in `~/.claude/settings.json`:

| Hook | Trigger | Effect |
|---|---|---|
| `UserPromptSubmit` | You submit a prompt | If prompt starts with `next: `, write rest to queue file, `exit 2` to block the prompt. No LLM call. |
| `Stop` | Claude ends a turn | If queue file exists for this `session_id`, emit `{"decision":"block","reason":"<text>"}` on stdout. Claude Code continues the turn with that text as the next instruction. |

Per-session isolation comes from keying the queue file on `session_id` (provided on stdin to every hook), so parallel Claude Code sessions don't collide.

## Install

1. Clone somewhere:
   ```sh
   git clone <repo> ~/PycharmProjects/hook-next
   chmod +x ~/PycharmProjects/hook-next/hooks/*.sh
   ```
2. Merge `settings.example.json` into `~/.claude/settings.json` (or wire the hooks into a project-local `.claude/settings.json`). If you already have hooks, add these under the existing `"hooks"` key.
3. Start a new Claude Code session (hooks load at session start).

## Usage

```
> next: after you finish, list all .md files in this repo
> what's 2+2?
```

Claude answers "4", stops, Stop hook fires, Claude continues with the listing.

## Requirements

- `bash`, `jq`
- Claude Code (tested on 2.1.x)

## Files

- `hooks/queue_next.sh` — `UserPromptSubmit` handler
- `hooks/feed_next.sh` — `Stop` handler
- `settings.example.json` — hook wiring you merge into `~/.claude/settings.json`
