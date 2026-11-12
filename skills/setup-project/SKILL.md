---
name: setup-project
description: Bring a repository onto the agent-kit workflow — project AGENTS.md, CLAUDE.md import, CI, issue and PR templates, secret protection. Use when the user says /setup-project or starts working in a repo without an AGENTS.md that follows the kit template.
---

# /setup-project — onboard a repo to the kit

Work on a branch: `git switch -c chore/agent-kit-setup`. Templates are in `~/GIT/agent-kit/templates/project/`.

1. **Inspect** (cheaply): manifest files (`package.json`, `pyproject.toml`, `go.mod`…), lockfile → package manager, framework, test runner, existing CI (`.github/workflows`), existing agent files (`AGENTS.md`, `CLAUDE.md`, `.cursor/rules`, `.agents/`, memory/ledger files), secret-looking files (`.env*`, `private/`, keys).
2. **Stacks:** match what you found to the packs in `~/GIT/agent-kit/stacks/` and list them in the `Stacks:` line. A technology without a pack: note it in the PR (a pack may be worth writing).
3. **Suggest a mode** and confirm it with the user before going further:
   - `product`: has a deployed site with sign-in, payments, real users or real personal data.
   - `prototype`: an app being built, deployed or not, without real users yet.
   - `sandbox`: course work, tutorials, experiments, archives.
   For `sandbox`, only steps 4 (AGENTS.md), 5 (CLAUDE.md) and 7 (secrets) are needed; skip CI, templates and labels.
4. **Project `AGENTS.md`** from `templates/project/AGENTS.md`:
   - Fill Stack, Commands (exact commands that work — run each once to confirm), Architecture (≤10 lines + links), Rules (only project-specific, keep the good ones from existing agent files), Release, Design and voice (point to existing design/brand docs; if the project has a UI but no voice file, note it and suggest `/content` to draft one).
   - Target: under ~150 lines. Move long history/ledgers to `docs/history/` instead of deleting them; mention that in the PR.
5. **`CLAUDE.md`** at the root containing just `@AGENTS.md` (Claude Code does not read AGENTS.md on its own). Same in any subfolder that has its own `AGENTS.md`.
6. **GitHub**: copy `templates/project/github/` into the repo as `.github/` (CI, issue template, PR template). Adapt CI steps to the real commands; keep existing workflows unless they duplicate. Required checks should be fast and reliable; slow or flaky checks run but are not required.
7. **Secrets**: ensure `.gitignore` covers `.env*` (except `.env.example`) and private folders. List any secret files found inside the repo folder and recommend moving them out — do not move or delete them yourself.
8. **Project skills**: keep project-specific skills in `.agents/skills/`. If an existing skill duplicates a kit skill, propose replacing it and keep only the project-specific steps (e.g. as `AGENTS.md` → Release).
9. **Labels**: `for l in in-progress:FBCA04 sub-issue:C5DEF5 bug:D73A4A regression:B60205 lesson:0E8A16 security:5319E7; do gh label create "${l%%:*}" --color "${l##*:}" --force; done`.
10. Open a PR with `/ship`. In the PR body list: what was created, what was moved, questions for the user.
