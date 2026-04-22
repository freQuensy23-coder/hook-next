# hook-next

Queue a prompt for Claude Code to run as soon as it finishes the current turn. No extra LLM call for the queueing itself.

```
> next: run the tests when you're done
> fix the bug in foo.py
```

Claude fixes the bug, stops, then picks up "run the tests" on its own.

## How

Two hooks in `~/.claude/settings.json`:

- `UserPromptSubmit` — if the prompt starts with `next: `, write the rest to `/tmp/claude-next-<session_id>.txt` and `exit 2` so the prompt never reaches the model.
- `Stop` — when the turn ends, if that file exists, print `{"decision":"block","reason":"<contents>"}` to stdout. Claude Code treats that as "don't stop, use this as the next instruction."

`session_id` is on stdin for both hooks, so parallel sessions don't clobber each other.

## Install

```sh
git clone git@github.com:freQuensy23-coder/hook-next.git ~/PycharmProjects/hook-next
chmod +x ~/PycharmProjects/hook-next/hooks/*.sh
```

Merge `settings.example.json` into `~/.claude/settings.json` under the existing `"hooks"` key. Start a new Claude Code session — hooks only load at session start.

Needs `bash` and `jq`.
