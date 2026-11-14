# Mode: audit — how findable is it today, and what to fix

Scope: the whole site, or the pages the owner names. Report only; fixes become tasks.

1. **What it should be found for.** From the project's strategy document or the owner: the audience, and the 10–20 searches and questions that matter ("best … for …", "how do I …", "… vs …", the brand name). None written down → propose a list and confirm it.
2. **Can it be read at all?** (the entry ticket for search and for AI answers)
   - Pages return their main content in the HTML the server sends, without needing JavaScript.
   - `robots.txt` lets search crawlers and AI crawlers fetch public pages (check what is blocked, on purpose or by accident); a `sitemap` lists the real pages; no important page is `noindex` or orphaned.
   - Canonical URLs, redirects and status codes are right; no duplicate versions of a page.
   - Fast and stable on a phone (Core Web Vitals); HTTPS; mobile layout works.
3. **Each key page.** One clear topic and intent; a unique title and meta description that say what the page offers; one `h1`, headings that outline the answer; the direct answer near the top; real, specific content (numbers, examples, screenshots) rather than generic copy; internal links to and from related pages; images with dimensions and `alt` text; structured data only for what the page truly shows.
4. **Trust and identity.** Clear who is behind it (about, contact, legal pages); the same name, description and facts everywhere; claims sourced; content dated and kept current.
5. **Presence beyond the site.** Search the web for the brand and for the target questions: who shows up, who is cited or recommended, where the product is mentioned (reviews, directories, communities, comparisons) and where it is absent.
6. **AI answers.** Where you have the means, ask the target questions the way a person would and note which sources are cited and which products are named. Record it as a baseline; say which engines you could not check.
7. **Report**, most valuable first:
   - **Blocking** (it cannot be found or read): what, where, the fix.
   - **High impact** (pages or topics that would win real searches).
   - **Housekeeping.**
   - **Not worth doing**, with the reason (so nobody is sold it later).
   Each item: the evidence, the fix, the effort (S/M/L) and how the result will be measured. Offer to turn the top items into tasks with `/k-task`.
