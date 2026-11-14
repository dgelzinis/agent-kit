#!/bin/sh
# Smoke-test install.sh in an isolated HOME. No real user configuration is touched.
set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
export HOME="$TMP/home"
mkdir -p "$HOME/.claude" "$HOME/.codex" "$HOME/.gemini"
printf 'existing claude config\n' > "$HOME/.claude/CLAUDE.md"
printf 'existing codex config\n' > "$HOME/.codex/AGENTS.md"
printf 'existing gemini config\n' > "$HOME/.gemini/GEMINI.md"
cat > "$HOME/.claude/settings.json" <<'JSON'
{
  "customSetting": true,
  "permissions": {
    "allow": ["Bash(git status:*)"],
    "deny": ["Read(./secrets/**)"]
  }
}
JSON

sh "$ROOT/install.sh"

# Global rules should link to the kit, and original files should be backed up.
test -L "$HOME/.claude/CLAUDE.md"
test -L "$HOME/.codex/AGENTS.md"
test -L "$HOME/.gemini/GEMINI.md"
test "$(readlink "$HOME/.claude/CLAUDE.md")" = "$ROOT/AGENTS.md"
test -n "$(find "$HOME/.agent-kit-backup" -name 'dot-claude__CLAUDE.md' -print -quit)"
test -n "$(find "$HOME/.agent-kit-backup" -name 'dot-codex__AGENTS.md' -print -quit)"
test -n "$(find "$HOME/.agent-kit-backup" -name 'dot-gemini__GEMINI.md' -print -quit)"
test -n "$(find "$HOME/.agent-kit-backup" -name 'dot-claude__settings.json' -print -quit)"

# Existing settings must survive the merge; secret deny rules must be added.
node - "$HOME/.claude/settings.json" <<'NODE'
const fs = require('fs');
const s = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
if (s.customSetting !== true) throw new Error('custom setting was lost');
if (!s.permissions.allow.includes('Bash(git status:*)')) throw new Error('existing allow rule was lost');
if (!s.permissions.deny.includes('Read(./secrets/**)')) throw new Error('existing deny rule was lost');
if (!s.permissions.deny.includes('Read(./.env)')) throw new Error('kit deny rules were not added');
NODE

# Skills and helper should be available; repeated installation must be safe.
test -L "$HOME/.agents/skills/k-code"
test -L "$HOME/.claude/skills/k-code"
test -x "$HOME/.local/bin/kit"
"$HOME/.local/bin/kit" help | grep -q 'Daily flow'
sh "$ROOT/install.sh"
test -L "$HOME/.claude/CLAUDE.md"
test -L "$HOME/.agents/skills/k-code"

echo "installer smoke test passed"
