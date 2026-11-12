---
name: setup-project
description: Bring a repository onto the agent-kit workflow — project AGENTS.md, CLAUDE.md import, CI, issue and PR templates, secret protection. Use when the user says /setup-project or starts working in a repo without an AGENTS.md that follows the kit template.
---

# /setup-project — onboard a repo to the kit

Work on a branch: `git switch -c chore/agent-kit-setup`. Templates are in `~/GIT/agent-kit/templates/project/`.

1. **Inspect** (cheaply): manifest files (`package.json`, `pyproject.toml`, `go.mod`…), lockfile → package manager, framework, test runner, existing CI (`.github/workflows`), existing agent files (`AGENTS.md`, `CLAUDE.md`, `.cursor/rules`, `.agents/`, memory/ledger files), secret-looking files (`.env*`, `private/`, keys).
2. **Project `AGENTS.md`** from `templates/project/AGENTS.md`:
   - Fill Stack, Commands (exact commands that work — run each once to confirm), Architecture (≤10 lines + links), Rules (only project-specific, keep the good ones from existing agent files), Release.
   - Target: under ~150 lines. Move long history/ledgers to `docs/history/` instead of deleting them; mention that in the PR.
3. **`CLAUDE.md`** at the root containing just `@AGENTS.md` (Claude Code does not read AGENTS.md on its own). Same in any subfolder that has its own `AGENTS.md`.
4. **GitHub**: copy `templates/project/github/` into the repo as `.github/` (CI, issue template, PR template). Adapt CI steps to the real commands; keep existing workflows unless they duplicate. Required checks should be fast and reliable; slow or flaky checks run but are not required.
5. **Secrets**: ensure `.gitignore` covers `.env*` (except `.env.example`) and private folders. List any secret files found inside the repo folder and recommend moving them out — do not move or delete them yourself.
6. **Project skills**: keep project-specific skills in `.agents/skills/`. If an existing skill duplicates a kit skill, propose replacing it and keep only the project-specific steps (e.g. as `AGENTS.md` → Release).
7. **Labels**: `gh label create in-progress --color FBCA04 --force; gh label create sub-issue --color C5DEF5 --force`.
8. Open a PR with `/ship`. In the PR body list: what was created, what was moved, questions for the user.
