---
name: k-design
description: UI and UX expertise before and after building — design a screen or flow first (who it is for, the flow, every state, a quick mockup to approve), and check the built result in a real browser at phone, tablet and desktop widths. Use when the user says /k-design, when a task changes what users see (during planning and before shipping), or when asked for design options or a UX review.
---

# /k-design — design it first, check it after

> **Project settings first:** if the project's `AGENTS.md` has `## Skill settings` → `### /k-design`, read it and apply it on top of this skill. Settings add steps or tighten rules; they never loosen the kit's Safety rules.

**Always start here:** read `~/GIT/agent-kit/stacks/ux.md` (general UX rules) and the project's design rules and voice (`AGENTS.md` → Design and voice / Skill settings). The project's rules win over the general ones.

**Which mode?** Nothing built yet for this task (planning, or the user asks for options) → **Design**. The branch already changes UI files, or the user says "check" or names a live page → **Check**. Unsure → ask. `/k-design options` and `/k-design check` force a mode.

## Design (before building)
1. **Who and why.** Who uses this screen, what they are trying to get done, and what they should see or do first. One sentence each. Look at the neighbouring screens so the new one behaves like its siblings.
2. **Flow.** The steps from arriving to done, as a short numbered list. Fewest steps that work; say what happens after the last one.
3. **States.** What it shows when: normal, empty (first use), loading, error, very long text or big numbers, no permission. On a phone (390px) and on desktop.
4. **Options.** One recommended layout, plus a second only if there is a real trade-off. Use the project's existing components and tokens; propose a new pattern only with a reason.
5. **Mockup.** A quick static mockup of the recommended option (and the alternative, if any): a single HTML file using the project's colours, type and spacing, saved **outside the repo** (temp folder). Screenshot it at 390px and 1440px with a browser tool if you have one. Give the owner the file path (`open <path>` shows it) and the screenshots. No browser tool → the HTML file alone.
6. **Words.** The headline, button labels and empty-state text, in the project's voice (`/k-content` for anything longer).
7. **Present it** with the plan at checkpoint 2: who/why, flow, states, mockup, and the open choices as questions. After the OK, record the agreed design on the issue (a short comment; the mockup path or screenshot) so the build and the later check have a reference.

## Check (after building)
Needs a browser tool (Playwright MCP, Claude in Chrome, or a Playwright script; none → say so and review the code and the project's existing browser checks instead) and the app running (see `AGENTS.md` → Commands; demo or test data, never a real user's account).
1. **Pages and states:** the pages the change touches, in every state from the design that you can reach.
2. **Widths:** 390px, 768px, 1440px. Screenshot each page × width × state. Save screenshots outside the repo or in a git-ignored folder; never commit them.
3. **Look for:**
   - Matches the agreed design (the comment on the issue), if there was one.
   - Layout: nothing cut off or overflowing; no horizontal scroll on phone; aligned with sibling pages; no jump when data loads.
   - Visual system: only design-system colours, type sizes and spacing; shared components, no one-offs.
   - States: loading, empty and error are designed, not blank or raw errors.
   - Interaction: one clear main action; tap targets at least 44px; focus visible; buttons say what they do; disabled controls explain why.
   - Accessibility: contrast, labels on inputs and icon buttons, headings in order, usable by keyboard.
   - Words: the project's voice, no placeholder or internal names.
   - Console: no errors or warnings while using the page.
4. **Report** per page: screenshots (or paths), then **Fix** (broken or inconsistent) and **Polish** (nice to have), each with where and a concrete suggestion. Inside the normal flow, fix the "Fix" items before the pull request; when called directly, do not edit unless asked.
