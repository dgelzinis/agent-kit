#!/usr/bin/env node
// kit stats — workflow numbers from GitHub for one repo or all kit projects.
//   kit stats                 current repo, last 30 days
//   kit stats --days 60       other period
//   kit stats --all           every repo under ~/GIT whose AGENTS.md has "Mode: product|prototype"
// Needs the GitHub CLI (gh), logged in.
import { execFileSync } from 'node:child_process';
import { existsSync, readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import { homedir } from 'node:os';

const args = process.argv.slice(2);
const days = Number(args[args.indexOf('--days') + 1]) || 30;
const all = args.includes('--all');
const since = new Date(Date.now() - days * 864e5);
const sinceDay = since.toISOString().slice(0, 10);

const gh = (cwd, a) => {
  try { return JSON.parse(execFileSync('gh', a, { cwd, encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }) || '[]'); }
  catch { return null; }
};
const median = (xs) => {
  if (!xs.length) return null;
  const s = [...xs].sort((a, b) => a - b); const m = Math.floor(s.length / 2);
  return s.length % 2 ? s[m] : (s[m - 1] + s[m]) / 2;
};
const round = (x) => (x == null ? '—' : Math.round(x * 10) / 10);

function modeOf(dir) {
  const f = join(dir, 'AGENTS.md');
  if (!existsSync(f)) return null;
  const m = readFileSync(f, 'utf8').match(/^Mode:\s*(product|prototype|sandbox)/m);
  return m ? m[1] : 'product';
}

function stats(dir) {
  const prs = gh(dir, ['pr', 'list', '--state', 'merged', '--limit', '200', '--search', `merged:>=${sinceDay}`,
    '--json', 'number,createdAt,mergedAt,additions,deletions,comments,title']);
  if (prs === null) return { error: 'gh failed (not a GitHub repo, or not logged in)' };
  const hours = prs.map((p) => (new Date(p.mergedAt) - new Date(p.createdAt)) / 36e5);
  const size = prs.map((p) => p.additions + p.deletions);
  const verdicts = prs.flatMap((p) => (p.comments || []).map((c) => c.body.match(/Verdict:\s*(BLOCKED|OK WITH FIXES|OK)\b/)?.[1]).filter(Boolean));
  const blocked = verdicts.filter((v) => v === 'BLOCKED').length;
  const reviewed = prs.filter((p) => (p.comments || []).some((c) => /Verdict:/.test(c.body))).length;
  const runs = gh(dir, ['run', 'list', '--limit', '200', '--created', `>=${sinceDay}`, '--json', 'conclusion']) || [];
  const done = runs.filter((r) => r.conclusion);
  const failed = done.filter((r) => r.conclusion === 'failure').length;
  const numbers = (label) => (gh(dir, ['issue', 'list', '--state', 'all', '--label', label, '--limit', '200',
    '--search', `created:>=${sinceDay}`, '--json', 'number']) || []).map((i) => i.number);
  const count = (...labels) => new Set(labels.flatMap(numbers)).size;
  return {
    merged: prs.length,
    medianHoursToMerge: round(median(hours)),
    medianPrSize: round(median(size)),
    reviewedShare: prs.length ? `${Math.round((100 * reviewed) / prs.length)}%` : '—',
    blockedReviews: blocked,
    ciFailureRate: done.length ? `${Math.round((100 * failed) / done.length)}%` : '—',
    bugs: count('bug', 'regression'),
    lessons: count('lesson'),
    security: count('security'),
  };
}

const repos = all
  ? readdirSync(join(homedir(), 'GIT'), { withFileTypes: true })
      .filter((d) => d.isDirectory())
      .map((d) => join(homedir(), 'GIT', d.name))
      .filter((d) => existsSync(join(d, '.git')) && ['product', 'prototype'].includes(modeOf(d)))
  : [process.cwd()];

const rows = {};
for (const dir of repos) {
  const name = dir.split('/').pop();
  process.stderr.write(`… ${name}\n`);
  rows[`${name} (${modeOf(dir) ?? 'no AGENTS.md'})`] = stats(dir);
}
console.log(`\nLast ${days} days (since ${sinceDay})`);
console.table(rows);
console.log('Lower is better: hours to merge, PR size, blocked reviews, CI failures, bugs. Reviewed share should be ~100% in product mode.');
