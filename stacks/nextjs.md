# Stack pack: Next.js (marketing and content sites)

**Standards:** the Next.js docs for the installed version (nextjs.org/docs), Core Web Vitals (web.dev/vitals) for speed, Google Search Central (developers.google.com/search) for SEO, and WCAG 2.2 AA for accessibility (see the `ux` pack).

## Content and SEO
- Every page: unique `title` and meta description, one `h1`, canonical URL, Open Graph image and text. Use the framework's metadata API, not hand-written tags.
- `sitemap` and `robots` generated from the real routes; no links to pages that 404 (check internal links when adding or renaming pages).
- Images through the framework's image component with width/height (no layout shift) and real `alt` text.
- Structured data (JSON-LD) only for facts the page really shows.

## Rendering
- Default to static generation for marketing pages; server-only code (secrets, database) never imported into client components.
- Mark client components explicitly and keep them small; heavy libraries only where needed (dynamic import).
- Env vars with the public prefix are visible to everyone.

## Quality
- Core Web Vitals: check LCP image, font loading (`display: swap`, preloaded), no layout shift from banners or embeds.
- Analytics and tracking load after consent where required; no personal data in URLs or events.
- Forms post to a server route with validation and spam protection; never expose app database credentials on the marketing site.
- Build must pass with zero lint warnings before shipping.
