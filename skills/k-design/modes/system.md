# Mode: system — create or revise the design system

A design system is the small set of decisions every screen reuses: colours, type, spacing, components and the rules for using them. It lives in one document and in the shared components, never page by page.

1. **Find what exists.** The project's design document (`AGENTS.md` → Design and voice), its tokens (CSS variables, theme files) and shared components. No document yet → this mode creates one at `docs/brand/design-system.md` (or where the project keeps brand docs).
2. **Audit the real screens.** Open the main pages at 390px and 1440px (browser tool; demo or test data). List what is inconsistent: how many different greys, font sizes, spacings, button styles, card styles, table styles; where the same thing looks different on two pages. Count them; the numbers make the case.
3. **Propose the system,** small enough to remember:
   - **Colour:** a neutral scale, one brand colour, and semantic colours (success, warning, danger, info), each with a text-safe pairing that passes WCAG AA. Named by role, not by hue.
   - **Type:** one or two families; a scale of about 5–7 sizes with line heights and weights; tabular figures for numbers.
   - **Spacing and shape:** one spacing scale (e.g. 4, 8, 12, 16, 24, 32, 48), radii, borders, shadows, breakpoints.
   - **Components:** the core set the product actually uses (button, input, select, card, table or list, modal, tabs, banner, empty state), each with its variants and its states (hover, focus, disabled, loading, error).
   - **Rules:** when to use which; what is not allowed (hard-coded colours, one-off spacing, a new variant without a reason).
   Reuse what already works; change only what the audit shows is a problem.
4. **Show it** before anything is built: one sample page as a static mockup (saved outside the repo) that uses the proposed tokens and components, at phone and desktop width, next to a screenshot of the same page today. Present it at checkpoint 2 with the audit numbers and the open choices as questions.
5. **After the OK, build it in this order,** each step its own small pull request:
   1. the document;
   2. the tokens (variables or theme) in one place;
   3. the shared components, changed to use the tokens;
   4. pages moved over one at a time, each followed by a check (`modes/check.md`).
   Never restyle a page directly to match: if a page needs something the system lacks, add it to the system first.
6. **Make it stick.** Point the project at it (`/ka-project tune` → `### /k-design` → `Rules: <path>`), and propose a lint rule or test that fails on hard-coded colours or spacing where the stack allows it.
7. **Revising later** follows the same steps on a smaller scale: audit the part in question, propose the change with before and after, update the document and the shared piece, then check the pages that use it.
