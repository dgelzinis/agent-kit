# Mode: design — a screen or flow, before building
1. **Who and why.** Who uses this screen, what they are trying to get done, and what they should see or do first. One sentence each. Look at the neighbouring screens so the new one behaves like its siblings.
2. **Flow.** The steps from arriving to done, as a short numbered list. Fewest steps that work; say what happens after the last one.
3. **States.** What it shows when: normal, empty (first use), loading, error, very long text or big numbers, no permission. On a phone (390px) and on desktop.
4. **Options.** One recommended layout, plus a second only if there is a real trade-off. Use the project's existing components and tokens; propose a new pattern only with a reason.
5. **Mockup.** A quick static mockup of the recommended option (and the alternative, if any): a single HTML file using the project's colours, type and spacing, saved **outside the repo** (temp folder). Screenshot it at 390px and 1440px with a browser tool if you have one. Give the owner the file path (`open <path>` shows it) and the screenshots. No browser tool → the HTML file alone.
6. **Words.** The headline, button labels and empty-state text, in the project's voice (`/k-content` for anything longer).
7. **Present it** with the plan at checkpoint 2: who/why, flow, states, mockup, and the open choices as questions. After the OK, record the agreed design on the issue (a short comment; the mockup path or screenshot) so the build and the later check have a reference.
