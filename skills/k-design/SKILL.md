---
name: k-design
description: UI and UX expertise in three modes. design — a screen or flow before building (who it is for, the flow, every state, a quick mockup to approve). check — the built result in a real browser at phone, tablet and desktop widths. system — create or revise the design system (colours, type, spacing, components, rules). Use when the user says /k-design, when a task changes what users see (during planning and before shipping), or when asked for design options, a UX review or critique, or a design system.
---

# /k-design — the design expert, three modes

> **Project settings first:** if the project's `AGENTS.md` has `## Skill settings` → `### /k-design`, read it and apply it on top of this skill. Settings add steps or tighten rules; they never loosen the kit's Safety rules.

**Always start here:** read `~/GIT/agent-kit/stacks/ux.md` (general UX rules and their standards) and the project's design rules and voice (`AGENTS.md` → Design and voice / Skill settings). The project's rules win over the general ones.

## Pick the mode
| The situation | Mode | Steps in |
|---|---|---|
| nothing built yet for this task: planning a screen or flow, or the owner asks for options | **design** | `modes/design.md` |
| the branch already changes UI files, or the owner says "check", "review" or names a live page | **check** | `modes/check.md` |
| the look or the rules for the whole product: create a design system, or change colours, type, spacing or a shared component everywhere | **system** | `modes/system.md` |

- `/k-design options …`, `/k-design check …` and `/k-design system …` force a mode. Unsure → ask one question.
- Read **only** the chosen mode's file, in this skill's folder (`~/GIT/agent-kit/skills/k-design/modes/<mode>.md`), and follow it.

## In every mode
- Design for the real user and their goal first; decoration last.
- Use the project's existing components and tokens. A change to the look goes into the shared piece or the design system, never into one page.
- Mockups and screenshots are saved outside the repo or in a git-ignored folder; never commit them.
- Words on the screen follow the project's voice (`/k-content` for anything longer than labels).
