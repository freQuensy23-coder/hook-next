# hook-next

Queue a prompt for Claude Code that runs when the current turn ends.

```sh
qnext "then run the tests"
```

Works mid-turn from a separate terminal. The `Stop` hook picks up `/tmp/claude-next-<session_id>.txt` and feeds its contents back as the next prompt. `qnext` derives `session_id` from the most-recent `.jsonl` in `~/.claude/projects/<cwd-encoded>/`.

## Install

```sh
git clone git@github.com:freQuensy23-coder/hook-next.git ~/PycharmProjects/hook-next
chmod +x ~/PycharmProjects/hook-next/{bin/qnext,hooks/feed_next.sh}
ln -sf ~/PycharmProjects/hook-next/bin/qnext ~/.local/bin/qnext
```

Merge `settings.example.json` into `~/.claude/settings.json`, start a new Claude Code session. Needs `bash`, `jq`.
