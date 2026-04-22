# hook-next

Queue a follow-up prompt for Claude Code that fires when the current turn ends. Works mid-turn, via a plain CLI.

```sh
# in any terminal, while Claude is working:
qnext "run the tests after you finish"
```

When Claude's current turn ends, it automatically picks up "run the tests after you finish" as the next instruction. No extra LLM call for the queueing itself.

## Why a CLI and not a hook?

First draft used a `UserPromptSubmit` hook on a `next: ` prefix. That hook doesn't fire for mid-turn submissions — which is exactly when you want to queue — so the text leaked into Claude as a regular mid-turn message. The CLI sidesteps the issue by writing the queue file directly.

## How it works

- `bin/qnext` finds the active session's transcript at `~/.claude/projects/<cwd-encoded>/<session_id>.jsonl` (most recent mtime), extracts `session_id` from the basename, and writes your text to `/tmp/claude-next-<session_id>.txt`.
- `hooks/feed_next.sh` is a `Stop` hook. When Claude's turn ends, it reads that file (if present), deletes it, and emits `{"decision":"block","reason":"<text>"}` on stdout. Claude Code treats that as "don't stop — use this as the next instruction."

`session_id` is on stdin for every hook, so parallel sessions don't collide.

## Install

```sh
git clone git@github.com:freQuensy23-coder/hook-next.git ~/PycharmProjects/hook-next
chmod +x ~/PycharmProjects/hook-next/bin/qnext ~/PycharmProjects/hook-next/hooks/feed_next.sh
ln -sf ~/PycharmProjects/hook-next/bin/qnext ~/.local/bin/qnext   # or anywhere on $PATH
```

Merge `settings.example.json` into `~/.claude/settings.json` under the existing `"hooks"` key. Start a new Claude Code session — hooks only load at session start.

Needs `bash` and `jq`.

## Usage

```
> fix the bug in foo.py
```
…while Claude is working, from another terminal:
```sh
qnext "then run the test suite"
```
Claude fixes the bug, stops, then continues with "then run the test suite".

## Known quirks

- Claude Code renders the Stop hook's `decision:block` return as **"Stop hook error: &lt;text&gt;"** in the UI. It's not an error — it's the documented continuation mechanism. Cosmetic only.
- If multiple Claude Code sessions share the same cwd, `qnext` picks the one with the most recent transcript write. Rare; no flag for disambiguation yet.
