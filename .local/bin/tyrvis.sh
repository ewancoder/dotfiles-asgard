#!/usr/bin/env bash
set -euo pipefail

# The data layer. Nothing runs *in* it: Claude buckets sessions by cwd, so the
# main session gets its own folder to keep the boot bucket free of stray
# sessions started by hand in the project root. See sessions/README.md.
data="/mnt/data/tyrvis"

cd "$data/sessions/tyrvis"

# --resume takes a session ID. A bare name like "tyrvis" is treated as a search
# term and opens the interactive picker, which hangs forever under systemd with
# nobody attached. --continue resumes the most recent conversation in this
# directory without prompting -- but it errors out if there has never been one,
# so check before calling it.
sessions="$HOME/.claude/projects/${PWD//\//-}" # Claude stores sessions per cwd, slashes turned into dashes.

# --add-dir because cwd is an access boundary: without it the session still
# inherits the T.Y.R.V.I.S. identity from the parent CLAUDE.md, but gets a
# permission prompt on every read of the data layer and nobody is attached to
# answer it.
if ls "$sessions"/*.jsonl > /dev/null 2>&1; then
	exec ~/.local/bin/claude --continue --add-dir "$data" # We need exec to not fork it as Bash's child but to replace Bash.
else
	exec ~/.local/bin/claude --add-dir "$data" # Nothing to continue (first run here): start clean.
fi
