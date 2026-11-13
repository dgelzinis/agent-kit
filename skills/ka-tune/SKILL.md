---
name: ka-tune
description: Create or update a project's Skill settings — how strict security is, the content voice, design rules, extra review checks and so on — by asking the owner a few questions and writing them into the project's AGENTS.md. Use when the user says /ka-tune, wants a project to behave differently from the kit defaults, or /ka-setup-project reaches its settings step.
---

# /ka-tune — make the kit fit this project

Kit skills are the same everywhere. Each project tunes them in its `AGENTS.md` under `## Skill settings`, one `### /<skill>` block per skill that needs something different. No block = the kit default.

## Rules for settings
- Settings **add steps or tighten** a skill. They never loosen `AGENTS.md` → Safety or skip review/tests in `product` mode.
- Short: 1–5 lines per skill. Longer material lives in a file the setting points to (voice guide, design system, threat model).
- Only skills that need it. A small project may have no settings at all.
- Never copy a kit skill into the project to change it. If the project truly needs a different process, write a project skill with a **new** name in `.agents/skills/`.

## Flow
1. **Read** the project's `AGENTS.md` (mode, stacks, existing `## Skill settings`) and skim what exists: brand/voice docs, design system, security/architecture docs, legal pages. Note what you found — do not ask for things the repo already answers.
2. **Ask** (use your question tool if you have one; otherwise a short numbered list). Offer a recommended answer for each, based on what you found. `/ka-tune <skill>` asks only about that skill.
   1. **Security** — how strict? *standard* (kit default) / *strict* (sensitive data, payments, finance, health: run on every PR touching backend, data or AI; "should fix" in auth/payments counts as a blocker). Any extra checks (regulations, data that must never leave, spend caps)?
   2. **Content voice** — who reads it, tone in 3 words, words to use / avoid, language and spelling, emoji yes/no. Existing voice doc to point to?
   3. **Design** — where are the design rules, which screen widths matter, how to open the app with demo data?
   4. **Review** — anything the reviewer must always check in this project (core calculations, a shared component, accessibility level)?
   5. **Control** — the default is three checkpoints (task, plan, result) with the agent carrying on in between. Prefer to confirm every step? Should large tasks run their workers automatically, or do you drive them?
   6. **Anything else** — e.g. `/k-db-change` (where migrations are applied), `/k-release` (extra steps), `/k-plan` (always include X).
3. **Draft** the `## Skill settings` section. Pointers to existing docs beat new text. If a voice or security doc is needed and missing, offer to create a short one (`docs/brand/voice.md`, `docs/security/threat-model.md`) — under ~40 lines.
4. **Show** the draft (or the diff against the current section) and wait for OK.
5. **Write** it into `AGENTS.md`, placed after `## Rules`. On a branch for `product`/`prototype` projects (`chore/skill-settings`), then `/k-ship`; in `sandbox` mode, edit directly.
6. **Check:** every file a setting points to exists; nothing contradicts `## Rules` or the kit's Safety rules.

## Format
```markdown
## Skill settings
<!-- Tunes kit skills for this project. Adds or tightens; never loosens Safety. Edit with /ka-tune. -->

### Flow
Control: checkpoints (default) | step by step. Large tasks: ask (default) | automatic | manual.

### /k-security
Level: strict. Run on every PR touching <paths>, not only before releases.
Extra checks: <…>.

### /k-content
Voice: <file>. <tone in a few words>; <language/spelling>; <never …>.

### /k-design-check
Rules: <file>. Widths: <…>. Demo: <how to open with demo data>.

### /k-review
Also check: <project-specific must-checks>.
```
