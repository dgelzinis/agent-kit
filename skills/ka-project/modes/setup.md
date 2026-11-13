# Mode: setup — bring a repo onto the kit

Work on a branch: `git switch -c chore/agent-kit-setup`. Templates are in `~/GIT/agent-kit/templates/project/`.

1. **Inspect** (cheaply): manifest files (`package.json`, `pyproject.toml`, `go.mod`…), lockfile → package manager, framework, test runner, existing CI (`.github/workflows`), existing agent files (`AGENTS.md`, `CLAUDE.md`, `.cursor/rules`, `.agents/`, memory/ledger files), secret-looking files (`.env*`, `private/`, keys).
2. **Stacks:** match what you found to the packs in `~/GIT/agent-kit/stacks/` and list them in the `Stacks:` line. Also note which problem packs the project will need (`payments-stripe`, `ai-llm`, `api`…). A technology or recurring problem without a pack: note it in the PR and offer to draft one from the official docs (Standards line with sources, then rules; about 40 lines) as a pull request to the kit.
3. **Suggest a mode** and confirm it with the user before going further:
   - `product`: has a deployed site with sign-in, payments, real users or real personal data.
   - `prototype`: an app being built, deployed or not, without real users yet.
   - `sandbox`: course work, tutorials, experiments, archives.
   For `sandbox`, only steps 4 (AGENTS.md), 5 (CLAUDE.md) and 7 (secrets) are needed; skip CI, templates and labels.
   Also set `Base branch:`: `main`, unless the owner's day-to-day work lives on another long-lived branch (check `git branch -a` and where recent commits went; ask).
4. **Project `AGENTS.md`** from `templates/project/AGENTS.md`:
   - Fill Stack, Commands (exact commands that work — run each once to confirm), Architecture (≤10 lines + links), Rules (only project-specific, keep the good ones from existing agent files), Release, Design and voice (point to existing design/brand docs; if the project has a UI but no voice file, note it and suggest `/k-content` to draft one).
   - Target: under ~150 lines. Move long history/ledgers to `docs/history/` instead of deleting them; mention that in the PR.
5. **`CLAUDE.md`** at the root containing just `@AGENTS.md` (Claude Code does not read AGENTS.md on its own). Same in any subfolder that has its own `AGENTS.md`.
6. **GitHub**: copy `templates/project/github/` into the repo as `.github/` (CI, issue template, PR template). Adapt CI steps to the real commands; keep existing workflows unless they duplicate. Required checks should be fast and reliable; slow or flaky checks run but are not required.
7. **Secrets**: ensure `.gitignore` covers `.env*` (except `.env.example`) and private folders. List any secret files found inside the repo folder and recommend moving them out — do not move or delete them yourself.
8. **Skill settings:** run `/ka-project tune` (it asks a few questions — security strictness, content voice, design rules, review must-checks — and writes `## Skill settings`). Skip for `sandbox` unless the owner wants it.
9. **Project skills**: keep project-specific skills in `.agents/skills/`. If an existing skill duplicates a kit skill, propose replacing it and move its project-specific parts into `## Skill settings` (or `AGENTS.md` → Release).
10. **Hooks:** run `kit hooks` in the repo (pre-commit: no commits on `main`, secret scan). If the repo keeps hooks in a tracked folder (`core.hooksPath`), add a `pre-commit` there that calls `~/GIT/agent-kit/hooks/pre-commit`. For `product` projects also add `.github/dependabot.yml` (security updates) and tell the owner to switch on Dependabot alerts.
11. **Labels**: `for l in in-progress:FBCA04 sub-issue:C5DEF5 bug:D73A4A regression:B60205 lesson:0E8A16 security:5319E7; do gh label create "${l%%:*}" --color "${l##*:}" --force; done`.
12. Open a PR with `/k-ship`. In the PR body list: what was created, what was moved, questions for the user.

**No GitHub remote** (`git remote -v` is empty) or `sandbox` mode: skip the GitHub steps (CI, templates, labels, Dependabot, PR); commit the files directly and tell the owner what was skipped.
