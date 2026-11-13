# Mode: check — the built result, in a real browser
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
