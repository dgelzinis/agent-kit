---
name: release
description: Cut a release from main — version bump, tag and release notes from merged pull requests. Use only when the user says /release.
---

# /release — version, tag, notes

Runs from an up-to-date `main` with nothing uncommitted. Works whether or not `main` is protected.

1. **Prepare**: `git switch main && git pull`. Stop if `git status --short` is not empty or CI on main is red (`gh run list --branch main --limit 1`).
2. **What is in it**: last tag `git describe --tags --abbrev=0`; merged PRs since then:
   `gh pr list --state merged --base main --search "merged:>$(git log -1 --format=%cI <last-tag>)" --json number,title`
   Nothing merged → stop.
3. **Version** (SemVer): any `feat!`/`BREAKING CHANGE` → major; any `feat` → minor; otherwise patch. Show the list and the proposed version; wait for OK.
4. **Project-specific steps**: run what the project's `AGENTS.md` → Release lists (e.g. refresh screenshots, a version script with its "don't commit/tag" option).
5. **Release PR**:
   - `git switch -c release/<version>`, commit `chore(release): <version>`, push, `gh pr create --title "chore(release): <version>" --body "<list of PRs>"`.
   - Tell the user to merge it once CI is green. Wait.
6. **Tag and publish** after the merge:
   - `git switch main && git pull`
   - `git tag <version> && git push origin <version>`
   - `gh release create <version> --generate-notes`
7. Report the release link.
