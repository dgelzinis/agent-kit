---
name: k-code
description: The code expert — writes and changes code in one of four modes, each with its own strict steps. build (a new feature from an approved plan), fix (a bug; failing test first), refactor (restructure with no behaviour change), database (a safe schema or data migration). Use when the user says /k-code, after a plan is approved, or when asked to build, fix, debug, clean up, refactor, or change a table, column or migration.
---

# /k-code — one code expert, four modes

> **Project settings first:** if the project's `AGENTS.md` has `## Skill settings` → `### /k-code`, read it and apply it on top of this skill (it may have lines per mode: `Fix:`, `Refactor:`, `Database:`). Settings add steps or tighten rules; they never loosen the kit's Safety rules.

## 1. Pick the mode
| The work is… | Mode | Steps in |
|---|---|---|
| new behaviour: a feature, a change users or callers will notice | **build** | `modes/build.md` |
| something is broken or gives a wrong result | **fix** | `modes/fix.md` |
| same behaviour, better structure: clean up, split, rename, simplify | **refactor** | `modes/refactor.md` |
| a table, column, index, policy, trigger or data fix | **database** | `modes/database.md` |

- The approved plan names the mode; use that. `/k-code fix`, `/k-code refactor`, `/k-code database` or `/k-code build` force it.
- Not named and not obvious → ask one question; do not guess between build and refactor.
- **One mode per pull request.** A feature that needs a migration: do the database part by the database steps and the rest by the build steps, and say so in the pull request. A bug or a cleanup found while doing something else becomes its own issue, not a side change.

## 2. Say it, then follow that mode's file
State the mode in one line (`Mode: refactor — no behaviour change`). Then read **only** that mode's file, in this skill's folder (`~/GIT/agent-kit/skills/k-code/modes/<mode>.md`), and follow it step by step. The modes have different rules on purpose; do not mix them.

## 3. Always, in every mode
- **Read the knowledge packs for what you touch** (`~/GIT/agent-kit/stacks/`; the table in its `README.md` says which): always `code.md`; the project's technology packs for the areas involved; and the problem packs that apply (`testing`, `security`, `api`, `payments-stripe`, `ai-llm`). They name the industry standard and its source; check the current official docs for version-specific details.
- Search past lessons for the area (`gh issue list --label lesson --state all --search "<area>"`).
- Work on the issue's branch, never on the base branch. Stay inside the issue's scope.
- **Call the other experts; do not do their job yourself.** This holds in every mode, refactor included:
  - touches sign-in, permissions or data access, payments, personal or financial data, secrets, or AI calls → `/k-security` on the change before shipping; its "must fix" findings are fixed first;
  - changes, or could change, what users see → `/k-design` (design before building; check in the browser after);
  - user-facing words → `/k-content`.
- Finish by running the project's lint, build and tests until they pass, then `/k-ship`.
