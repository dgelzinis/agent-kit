#!/bin/sh
# agent-kit installer. Safe to run again after every change to the kit.
#  - Links the global rules into Claude Code, Codex and Gemini CLI.
#  - Links each skill into ~/.agents/skills (Codex, Gemini, Copilot) and ~/.claude/skills (Claude Code),
#    one link per skill, so skills you installed yourself stay untouched.
#  - Adds secret-file deny rules to ~/.claude/settings.json (merged, never overwritten).
#  - Installs the `kit` helper to ~/.local/bin.
# Anything it would replace is first copied to ~/.agent-kit-backup/<time>/.
set -e

KIT=$(cd "$(dirname "$0")" && pwd)
STAMP=$(date +%Y%m%d-%H%M%S)
BACKUP="$HOME/.agent-kit-backup/$STAMP"
backed_up=0

backup() { # backup <path> — copy a real file/dir (not our own link) before replacing it
  if [ -e "$1" ] && [ ! -L "$1" ]; then
    mkdir -p "$BACKUP"
    cp -R "$1" "$BACKUP/$(echo "$1" | sed "s|$HOME/||; s|^\.|dot-|; s|/|__|g")"
    echo "  backed up $1"
    backed_up=1
  fi
}

link() { # link <target> <link-path>
  mkdir -p "$(dirname "$2")"
  backup "$2"
  [ -d "$2" ] && [ ! -L "$2" ] && rm -rf "$2"
  ln -sfn "$1" "$2"
}

echo "agent-kit: $KIT"

echo "Global rules"
link "$KIT/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link "$KIT/AGENTS.md" "$HOME/.codex/AGENTS.md"
link "$KIT/AGENTS.md" "$HOME/.gemini/GEMINI.md"

echo "Skills"
for dir in "$KIT"/skills/*/; do
  name=$(basename "$dir")
  link "$KIT/skills/$name" "$HOME/.agents/skills/$name"
  link "$KIT/skills/$name" "$HOME/.claude/skills/$name"
  echo "  $name"
done

echo "Claude Code subagents"
for f in "$KIT"/claude/agents/*.md; do
  link "$f" "$HOME/.claude/agents/$(basename "$f")"
  echo "  $(basename "$f" .md)"
done

echo "Claude Code secret protection (~/.claude/settings.json)"
node - "$HOME/.claude/settings.json" <<'EOF'
const fs = require('fs');
const file = process.argv[2];
let s = {};
if (fs.existsSync(file)) {
  try { s = JSON.parse(fs.readFileSync(file, 'utf8')); }
  catch { console.error('  could not parse settings.json; left unchanged'); process.exit(0); }
}
const deny = [
  'Read(./.env)', 'Read(./.env.*)', 'Read(./**/.env)', 'Read(./**/.env.*)',
  'Read(./private/**)', 'Read(./**/*.pem)', 'Read(./**/*.key)',
];
s.permissions = s.permissions || {};
const before = new Set(s.permissions.deny || []);
s.permissions.deny = [...before, ...deny.filter(d => !before.has(d))];
fs.mkdirSync(require('path').dirname(file), { recursive: true });
fs.writeFileSync(file, JSON.stringify(s, null, 2) + '\n');
console.log(`  ${s.permissions.deny.length - before.size} deny rules added`);
EOF

echo "kit helper"
chmod +x "$KIT/bin/kit"
link "$KIT/bin/kit" "$HOME/.local/bin/kit"
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) echo "  add to your ~/.zshrc:  export PATH=\"\$HOME/.local/bin:\$PATH\"" ;;
esac

command -v gh >/dev/null 2>&1 || echo "Note: install the GitHub CLI (brew install gh) and run: gh auth login"

echo ""
if [ "$backed_up" = 1 ]; then
  echo "Your previous files are in $BACKUP"
  echo "If an old CLAUDE.md / AGENTS.md / GEMINI.md had rules you want to keep, move them into $KIT/AGENTS.md."
fi
echo "Done. Start a new agent session to pick up the changes."
