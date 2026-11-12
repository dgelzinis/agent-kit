---
name: k-design-check
description: Visual and UX check of pages in a real browser at phone, tablet and desktop widths, against the project's design rules. Use when the user says /k-design-check, or a change touches UI before /k-ship.
---

# /k-design-check — look at it like a user would

> **Project settings first:** if the project's `AGENTS.md` has `## Skill settings` → `### /k-design-check`, read it and apply it on top of this skill. Settings add steps or tighten rules; they never loosen the kit's Safety rules.

Needs a browser tool (Playwright MCP, Claude in Chrome, or a Playwright script; none available → say so and review the code and the project's existing browser checks instead) and the app running (see the project's `AGENTS.md` → Commands; use demo or test data, never a real user's account).

1. **Rules first.** Read the project's design rules (`AGENTS.md` → Rules / Design names the file). Note tokens, spacing scale, typography, component library, tone.
2. **Pages.** The pages the change touches (or those the user names). For each, the states that exist: normal, empty, loading, error, very long text/numbers, view-only role if any.
3. **Widths.** 390px (phone), 768px (tablet), 1440px (desktop). Screenshot each page × width × state you can reach. Save screenshots outside the repo (a temp folder) or in a git-ignored folder; never commit them.
4. **Check**
   - Layout: nothing overflows or is cut off; no horizontal scroll on phone; alignment consistent with sibling pages; no layout jump when data loads.
   - Visual system: only design-system colours, type sizes and spacing; shared components used instead of one-offs.
   - States: loading, empty and error are designed, not blank or raw errors.
   - Interaction: tap targets ≥ 44px on phone; focus visible; buttons say what they do; disabled controls explain why.
   - Accessibility basics: contrast, labels on inputs and icon buttons, headings in order.
   - Copy: matches the project's voice (see `/k-content`), no placeholder or internal names.
   - Console: no errors or warnings while using the page.
5. **Output** — per page: screenshots (or their paths), then findings as **Fix** (broken/inconsistent) and **Polish** (nice to have), each with where and a concrete suggestion. Do not edit files unless the user asks.
