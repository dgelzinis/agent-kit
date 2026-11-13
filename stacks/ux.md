# Stack pack: UX (every project with a user interface)

**Standards:** WCAG 2.2 level AA (w3.org/WAI/WCAG22/quickref) for accessibility; Nielsen's 10 usability heuristics (nngroup.com) for interaction; platform guidance for touch (targets of about 44–48px); Core Web Vitals (web.dev/vitals) for perceived speed.

General rules a good product designer applies without thinking. The project's own design system and voice win where they differ. Used by `/k-design`; read it before building or changing any screen.

## Every screen
- One job per screen, one clear main action. Secondary actions look secondary.
- The most important thing first and biggest: the number, the status, the next step. Details below or one tap away.
- Say where the user is and how to get back. Never a dead end: every state offers a next step.
- Consistent with its sibling screens: same place for titles, actions, filters and totals.
- Design all states: first use (empty, with a way to start), loading (same shape as the content), error (what happened, what to do), no permission (why, who can).
- Text people use, not system words. Buttons name the action ("Save balance", not "Submit").

## Forms and input
- Ask for as little as possible; sensible defaults; remember what was typed if something fails.
- Label every field; show format hints before the mistake, errors next to the field in plain words.
- Forgive: accept "3 100", "3,100", "3100"; confirm before destroying; offer undo where you can.
- One column on phones; the right keyboard for the field (numbers, email).

## Phone first
- Works at 390px with one thumb: main actions reachable, tap targets at least 44px, no horizontal scroll.
- Tables become cards or get a fixed first column; long names wrap or truncate with the full value reachable.

## Accessibility (WCAG AA)
- Text contrast at least 4.5:1; never colour alone for meaning (add an icon, sign or word).
- Everything reachable and visible by keyboard; inputs and icon buttons labelled; headings in order.
- Respect reduced motion; nothing flashes.

## Money and data apps
- Numbers right-aligned in columns, same decimals, currency shown; thousands separated; tabular figures.
- Missing data is "—" with a way to add it, never 0. Say as of when a figure is true.
- Explain changes ("+€240 since October, mostly ETF growth"), not just show them. No alarm colours for normal movement.
- Charts: a title that states the point, labelled axes, few colours, readable on a phone; the exact value on hover or tap.
- Anything that changes money or data shows what will happen before it happens.

## Marketing and content pages
- Above the fold: who it is for, what it does for them, one call to action. Proof (a real screen, a number, a name) close by.
- One idea per section; short paragraphs; real product screenshots over stock images.
- Fast: the main image and text appear immediately; nothing jumps as it loads.
- The same call to action repeated, not five different ones. Forms ask only what is needed.
