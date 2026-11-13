# <Project name> — project facts

Mode: product   <!-- product | prototype | sandbox — see ~/GIT/agent-kit/AGENTS.md → Project mode -->
Stacks: <e.g. react-vite, node-express, supabase>   <!-- packs in ~/GIT/agent-kit/stacks/ -->
Base branch: main   <!-- where issue branches start and pull requests go; change only while a long-lived branch (e.g. a redesign) is the real line of work -->

Global working rules come from `~/GIT/agent-kit/AGENTS.md`. This file adds what is specific to this project and wins where they differ.

## Product
One or two sentences: what it is, who uses it. User-facing name vs. repo name if they differ.

## Stack
- Language / framework:
- Data / hosting:
- Package manager: (only this one)

## Commands
Run from the repo root.
| What | Command |
|---|---|
| Install | |
| Dev server | |
| Lint (must be 0 warnings?) | |
| Typecheck / build | |
| Tests | |
| Extra checks (when you change X) | |

## Architecture
≤10 lines: main folders and what lives where, plus links to deeper docs.

## Rules
Only rules that are specific to this project and not obvious from the code. Prefer turning a rule into a test or lint rule; keep a line here only until it is enforced.
-

## Skill settings
<!-- Tunes kit skills for this project (strictness, voice, extra checks). Adds or tightens; never loosens Safety. Create/edit with /ka-project tune. Empty = kit defaults. -->

## Design and voice
- Design rules: <path, e.g. docs/brand/design-system.md> (used by `/k-design`)
- Voice: <path, e.g. docs/brand/voice.md> (used by `/k-content`)

## Database
- Schema doc: <path> · Migrations: <folder, naming e.g. v<N>_<name>.sql> · Applied by: <owner, where/how>

## Docs that must stay true
Which docs to update when related code changes (e.g. math/formula docs, API docs).

## Release
Project-specific release steps for `/k-release` (e.g. version script with its no-commit option, screenshots to refresh).

## Current work
GitHub Issues (`gh issue list`). Long-running features may link a design or handoff doc from their issue.
