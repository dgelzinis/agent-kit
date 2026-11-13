# Stack pack: React + Vite + TypeScript

**Standards:** the official React docs (react.dev, including the Rules of React and "You Might Not Need an Effect"), the TypeScript handbook (typescriptlang.org/docs), Vite docs (vite.dev), and the docs of the data library the project uses (e.g. TanStack Query). Check the current docs for the installed major version.

## Data
- Server data through the project's data layer (e.g. TanStack Query hooks), not `fetch` in components. One query key per resource; invalidate on mutation.
- Every data view has loading, empty and error states. Skeletons take the same space as the loaded content (no layout jump).
- Missing values render as a dash or "not set", never as `0` or `NaN`. Format numbers, money and dates through shared helpers with the user's locale and currency.

## Components
- Reuse the project's shared UI components and tokens; change the look in the shared piece, not one page. No hard-coded colours or inline styles for theming.
- State that resets per item (forms, modals) must reset when the item changes (`key` or explicit reset), or it leaks between entries.
- Effects: list every dependency; prefer derived values over effects that sync state. No async work in render.
- Lists: stable `key` from data ids, never the array index for editable lists.

## TypeScript
- No `any` or `@ts-ignore` without a comment explaining why. Types for API data live next to the client code that fetches it.
- `strict` stays on.

## Build and runtime
- Env vars exposed to the browser (`VITE_*`) are public. Never put secrets there.
- After a deploy, old tabs may request chunks that no longer exist: lazy imports need a retry/reload fallback.
- Check the browser console: zero errors and React warnings on the pages you touched.
- Test at phone width (390px); no horizontal scroll.
