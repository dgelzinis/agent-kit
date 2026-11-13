# Stack pack: code design (every project)

**Standards:** the SOLID principles; "Refactoring" (Fowler) for naming code smells and safe moves; the language's own style guide and the project's linter as the final word on formatting.

How code should be shaped, whatever the language. These are the SOLID principles in practical form, balanced by "keep it simple". Used by `/k-code` in every mode and checked by `/k-review`. The project's own rules win where they differ.

## The five principles, as they apply here
- **One job each (Single responsibility).** A function, component, route or module does one thing and has one reason to change. A route handler handles the request; the business rule lives in a service or shared module; the database query lives in one place. A React component shows things; data fetching is in a hook; calculations are in plain functions.
- **Extend without editing what works (Open/closed).** Where the code already varies by kind (asset types, plans, providers), add a new kind by adding a case in one obvious place, not by editing every caller. Do not build an extension point for variation that does not exist yet.
- **Same promise for every variant (Liskov).** Anything that stands in for another (a mock, a second provider, a subtype) accepts the same inputs and keeps the same guarantees: same shape of result, same errors, same units and rounding.
- **Small, specific interfaces (Interface segregation).** Functions and components take only what they use. No "options" object with twenty fields; no component that needs the whole user to show a name.
- **Depend on the rule, not the detail (Dependency inversion).** Business logic does not import the web framework, the database client or the UI library. Pass those in, or keep them at the edges. This is what makes the logic testable without a server or a browser.

## Kept in balance by
- **Simplest thing that works.** No layer, interface, factory or setting until a second real use needs it. Three similar lines are better than a wrong abstraction.
- **One source of truth.** A business rule, formula or validation exists once and is imported everywhere. Finding a second copy is a bug.
- **Names say what it is for.** Read aloud, a function name tells you what you get; no abbreviations a newcomer must decode.
- **Small and flat.** Short functions, early returns, little nesting. A file that needs a table of contents wants splitting.
- **Errors are part of the design.** Decide what the caller sees when it fails; never swallow an error or return a fake default.
- **Pure where possible.** Calculations take inputs and return outputs, with no hidden reads of time, globals or the network.

## When they pull against each other
Clarity for the next reader wins. If applying a principle makes the code longer and harder to follow for no present benefit, don't. Say in the pull request when you chose simplicity over structure, or the reverse, and why.
