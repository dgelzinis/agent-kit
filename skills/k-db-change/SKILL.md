---
name: k-db-change
description: Make a database schema or data change safely — numbered migration, safe on existing data, access rules for new tables, tested, documented, and verified live after the owner applies it. Use when the user says /k-db-change or any task needs a table, column, index, policy, trigger or data fix.
---

# /k-db-change — schema changes without surprises

> **Project settings first:** if the project's `AGENTS.md` has `## Skill settings` → `### /k-db-change`, read it and apply it on top of this skill. Settings add steps or tighten rules; they never loosen the kit's Safety rules.

Agents write and test migrations. **Only the owner applies them to the live database.**

1. **Know the current schema.** Read the project's database doc (`AGENTS.md` names it) and the latest migrations in the migrations folder. If a read-only database connection or schema dump is available, compare — do not trust docs alone. Check the project's history/lessons for the tables involved.
2. **Design the change** and put it in the plan (`/k-plan`):
   - What changes and why; which code reads/writes it.
   - **Existing rows:** what happens to them (defaults, backfill, NULLs). Never assume an empty table.
   - **Rollout order:** can old code run against the new schema while deploying? Prefer *expand → migrate code → contract*: add new things first, remove old things in a later migration.
3. **Write the migration** as a new file with the next free number and the project's naming (e.g. `v113_<what>.sql`):
   - Re-runnable: `IF NOT EXISTS`, `CREATE OR REPLACE`, `DROP … IF EXISTS` before re-creating policies.
   - Additive by default. Destructive steps (drop/rename column, delete data, tighten constraints) only with explicit owner OK, in their own migration.
   - **Access rules:** every new table gets row-level security enabled plus policies matching the project's role model; columns users must not write are protected (e.g. a trigger or a restricted update policy). Re-check policies when changing existing tables.
   - Indexes for new foreign keys and frequent filters.
   - Money as exact numeric types (never float); timestamps with time zone.
   - A header comment: purpose, safe-to-rerun yes/no, how to verify.
4. **Test it** where possible: run against a local or branch database, or at least parse it; add or update tests for the code and for access rules (a user from another account cannot read/write the new rows).
5. **No silent fallbacks.** Code must fail loudly (clear error, log) if the table/column is missing — never quietly switch to in-memory or default data.
6. **Update docs** the change makes wrong (database doc, data model, API doc).
7. **In the PR**, add an "Apply" section for the owner:
   ```
   ## Apply (owner)
   1. Run database/migrations/v113_<what>.sql in <where the project applies migrations>.
   2. Verify: <one SQL query or check that proves it is live>.
   3. Then merge / deploy (or: deploy first, then apply — say which and why).
   ```
8. After the owner applies it, run the verification (or ask the owner to) and note the result on the issue.
