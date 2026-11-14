#!/bin/sh
# agent-kit installer. Safe to run again after every change to the kit.
#  - Links the global rules into Claude Code, Codex and Gemini CLI.
#  - Links each skill in skills/ into ~/.agents/skills (Codex, Gemini, Copilot) and ~/.claude/skills (Claude Code),
#    one link per skill, so skills you installed yourself stay untouched.
#  - Links the kit-only admin skills in admin/ into this repo's own .claude/skills and .agents/skills,
#    so they show up only when you work inside the kit.
#  - Adds secret-file deny rules to ~/.claude/settings.json (merged, never overwritten).
#  - Installs the `kit` helper to ~/.local/bin.
# Anything it would replace is first copied to ~/.agent-kit-backup/<time>/.
set -e

# Fail before changing the machine if the installer dependency is missing.
command -v node >/dev/null 2>&1 || { echo "agent-kit: Node.js is required by install.sh. Install Node.js and run this script again."; exit 1; }

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
# Remove links left by skills that were renamed or deleted in the kit (only links that point into this kit).
for d in "$HOME/.agents/skills" "$HOME/.claude/skills" "$HOME/.claude/agents"; do
  [ -d "$d" ] || continue
  for l in "$d"/*; do
    [ -L "$l" ] || continue
    case "$(readlink "$l")" in
      "$KIT"/*) [ -e "$l" ] || { rm "$l"; echo "  removed old link $(basename "$l")"; } ;;
    esac
  done
done
for dir in "$KIT"/skills/*/; do
  name=$(basename "$dir")
  if [ ! -f "$dir/SKILL.md" ]; then rmdir "$dir" 2>/dev/null || true; continue; fi
  link "$KIT/skills/$name" "$HOME/.agents/skills/$name"
  link "$KIT/skills/$name" "$HOME/.claude/skills/$name"
  echo "  $name"
done

echo "Kit-only admin skills (visible only when working inside $KIT)"
for dir in "$KIT"/admin/*/; do
  [ -d "$dir" ] || continue
  name=$(basename "$dir")
  for d in "$KIT/.claude/skills" "$KIT/.agents/skills"; do
    mkdir -p "$d"
    ln -sfn "../../admin/$name" "$d/$name"
  done
  echo "  $name"
done

w=$(ls "$KIT"/skills/k-*/SKILL.md 2>/dev/null | wc -l | tr -d ' ')
a=$(ls "$KIT"/skills/ka-*/SKILL.md "$KIT"/admin/*/SKILL.md 2>/dev/null | wc -l | tr -d ' ')
echo "  $w of 15 work skills, $a of 5 admin skills"
[ "$w" -gt 15 ] && echo "  WARNING: more than 15 work skills. Replace or merge one."
[ "$a" -gt 5 ] && echo "  WARNING: more than 5 admin skills. Replace or merge one."

echo "Claude Code subagents"
for f in "$KIT"/claude/agents/*.md; do
  link "$f" "$HOME/.claude/agents/$(basename "$f")"
  echo "  $(basename "$f" .md)"
done

echo "Claude Code permissions (~/.claude/settings.json): block secrets, allow reading the kit"
backup "$HOME/.claude/settings.json"
node - "$HOME/.claude/settings.json" "$KIT" "$HOME" <<'EOF'
const fs = require('fs');
const file = process.argv[2];
const kit = process.argv[3], home = process.argv[4];
const kitRead = kit.startsWith(home + '/') ? `Read(~/${kit.slice(home.length + 1)}/**)` : `Read(/${kit}/**)`;
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
const allow = new Set(s.permissions.allow || []);
if (!allow.has(kitRead)) s.permissions.allow = [...allow, kitRead];
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
