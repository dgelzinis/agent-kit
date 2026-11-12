---
name: k-release
description: Cut a release from main — version bump, tag and release notes from merged pull requests. Use only when the user says /k-release.
---

# /k-release — version, tag, notes

> **Project settings first:** if the project's `AGENTS.md` has `## Skill settings` → `### /k-release`, read it and apply it on top of this skill. Settings add steps or tighten rules; they never loosen the kit's Safety rules.

Runs from an up-to-date `main` with nothing uncommitted. Works whether or not `main` is protected.

0. **Resume?** If a merged `release/<version>` PR exists whose version has no tag yet (`gh pr list --state merged --search "chore(release) in:title" --limit 1`, `git tag -l <version>`), skip to step 7.
1. **Prepare**: `git switch main && git pull`. Stop if `git status --short` is not empty or CI on main is red (`gh run list --branch main --limit 1`).
2. **What is in it**: last tag `git describe --tags --abbrev=0` (no tags yet → first release: use the version in the project's manifest and list all merged PRs); merged PRs since then:
   `gh pr list --state merged --base main --search "merged:>$(git log -1 --format=%cI <last-tag>)" --json number,title`
   Nothing merged → stop.
3. **Version** (SemVer): any `feat!`/`BREAKING CHANGE` → major; any `feat` → minor; otherwise patch. Show the list and the proposed version; wait for OK.
4. **Security** (`product` mode): run `/k-security` on the changes since the last tag (`git diff <last-tag>..HEAD`), unless every merged PR in the list already had one. "Must fix" findings stop the release.
5. **Project-specific steps**: run what the project's `AGENTS.md` → Release lists (e.g. refresh screenshots, a version script with its "don't commit/tag" option).
6. **Release PR**:
   - `git switch -c release/<version>`, commit `chore(release): <version>`, push, `gh pr create --title "chore(release): <version>" --body "<list of PRs>"`.
   - Tell the user to merge it once CI is green. Wait; if the session ends, running `/k-release` again resumes here.
7. **Tag and publish** after the merge:
   - `git switch main && git pull`
   - `git tag <version> && git push origin <version>`
   - `gh release create <version> --generate-notes`
8. Report the release link.
