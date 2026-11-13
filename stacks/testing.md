# Problem pack: testing (every project)

**Standards:** the test pyramid (many fast unit tests, fewer integration tests, a handful of end-to-end checks); Arrange-Act-Assert structure; the framework's own docs (playwright.dev for browser tests, the test runner the project uses).

## What to test
- Every rule that calculates, converts, rounds or decides: money, dates, permissions, validation, state changes. Include the edges: zero, negative, empty, missing, very large, the boundary value and one past it.
- Every bug fixed gets a regression test that failed before the fix.
- Access rules: a second user cannot read or change the first user's data.
- A few end-to-end checks for the journeys that must never break (sign in, the main action, pay). Not every screen.

## How
- Test behaviour through the public interface (inputs → outputs), not private details; a refactor should not break tests.
- One reason to fail per test; the name states the behaviour ("a loan with no rate shows no interest").
- Deterministic: fix the clock and random seeds, no real network, no dependence on test order or on today's date.
- Fast: unit tests run in seconds so they run on every change. Slow or flaky tests are fixed or removed, never ignored.
- Realistic data from small builders or fixtures; never production data or real personal details.

## Not worth testing
- The framework or library itself; trivial getters; exact wording or pixel positions (use a browser check for layout that matters).

## In the flow
- Run the relevant tests after each step; the full suite before `/k-ship`. A red suite is never "probably unrelated": find out.
- Never weaken or delete a test to get green. If the expected behaviour changed on purpose, change the test and say so in the pull request.
