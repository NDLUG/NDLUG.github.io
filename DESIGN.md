# Notre Dame Linux User Group — Website (Design Document)

## Overview

A statically rendered website for the Notre Dame Linux User Group (NDLUG),
driven by the repository's directory structure and Markdown files. The site has
two parts: a **landing page** (about the club, community links, and the
semester schedule) and a **meetings log** — a blog-like archive where each post
holds a meeting's notes and materials. Adding or editing content is done purely
by creating or modifying Markdown files and committing them — no code changes
required for routine content updates.

The aesthetic is deliberately software-flavored: a monospace typeface, a Notre
Dame gold-and-navy palette, a narrow terminal-like measure, and no decorative
flourishes.

## Goals & Non-Goals

**Goals**
- Author content as Markdown; site structure follows the content directory tree.
- Fully static output — no server-side runtime, no database.
- Fast, accessible, privacy-respecting (no third-party trackers, no external font
  CDNs).
- Push-to-deploy: committing to `main` publishes the site automatically.

**Non-Goals (for this version)**
- Comments / discussion.
- Analytics.
- Site search.
- A manual light/dark toggle (color scheme follows the device only).
- Multi-author accounts or any authenticated/admin UI.

## Tech Stack

- **Static site generator:** [Hugo](https://gohugo.io/), **standard edition** (the
  extended/Sass edition is not required — styles are plain CSS). The version is pinned
  in `.hugo-version` (currently `0.159.2`) and read by CI so local and CI builds match.
  - *Styling:* hand-written **plain CSS** (no SCSS/Sass, no build-time preprocessor).
    The CSS is still bundled, minified, and fingerprinted through Hugo Pipes — see
    Implementation. (Hugo extended would only be needed again if build-time image
    processing is added later.)
- **Theme:** Custom, built from scratch inside this repo (no third-party theme
  dependency). Layouts live under `layouts/`, styles under `assets/`.
- **Hosting:** GitHub Pages.
- **Source control:** GitHub.
- **CI/CD:** GitHub Actions — builds with Hugo and deploys to GitHub Pages on
  every push to `main`.

## Repository Layout

```
.
├── DESIGN.md
├── README.md                 # quickstart + one-time deploy setup
├── hugo.toml                 # site config (baseURL, params, taxonomies, markup)
├── .hugo-version             # pinned Hugo version, read by CI
├── .github/
│   └── workflows/
│       └── deploy.yml        # build + deploy to GitHub Pages on push to main
├── archetypes/
│   └── meeting.md            # front-matter template for new meetings
├── assets/                   # processed by Hugo Pipes (fingerprinted)
│   ├── css/                  # main.css (styles + @font-face) + chroma.css (GitHub)
│   ├── js/                   # anchors.js (clipboard copy for heading links)
│   └── images/               # logo.svg (placeholder club mark)
├── layouts/
│   ├── _default/            # baseof, single, list, term, taxonomy, 404
│   │   └── _markup/         # render hooks: heading, image
│   ├── meetings/           # meetings listing (list.html)
│   ├── index.html          # landing page
│   └── partials/           # head, footer, social, article-meta, tags, ...
├── static/
│   ├── fonts/                # self-hosted Commit Mono woff2 files
│   └── favicon.svg
└── content/
    ├── _index.md             # landing page (about + schedule table)
    └── meetings/
        ├── _index.md         # meetings listing page
        └── <slug>/           # page bundle: index.md + its figures/materials
            ├── index.md
            └── figure0.webp
```

Notes:
- Hugo serves content from `content/`. Each meeting is a **leaf page bundle** (a
  directory containing `index.md` plus its own image/material assets), which keeps
  figures and slides colocated with the notes that reference them.
- `_index.md` files define **list/section** pages (landing page and the meetings
  index); `index.md` files define individual leaf pages (meetings).

## Routing

- `/` → `content/_index.md` (landing page)
- `/meetings/` → `content/meetings/_index.md` (meetings listing)
- `/meetings/<slug>/` → a meeting bundle
- `/tags/` and `/tags/<tag>/` → tag taxonomy pages (see Tags)
- `/index.xml` → RSS feed (see RSS)

## Design / Aesthetic

A clean, software-flavored feel in Notre Dame colors — gold and deep navy.

- **Color:** A gold-and-navy palette drawn from the Notre Dame identity. In light
  mode, a warm off-white/cream page with deep navy text and a darker gold used
  sparingly for links and hover states. In dark mode, a very deep navy page with
  warm off-white text and a brighter gold accent. Colors are kept soft rather than
  pure `#fff`/`#000` to reduce glare, and both palettes maintain sufficient
  contrast. Meant to read as classy and restrained, not obnoxious.
- **Color scheme selection:** Driven entirely by the device via the
  `prefers-color-scheme` media query. No in-page toggle. Implemented with CSS
  custom properties (a default `:root` palette plus a
  `@media (prefers-color-scheme: dark)` override) so there is no flash and no
  JavaScript dependency.
- **Typography:** A self-hosted open-source monospace as the primary face —
  **Commit Mono** (Latin subset, weights 400/500/700 + 400 italic) — bundled in
  `static/fonts/` and served from our own origin (no Google Fonts / external CDN),
  declared via `@font-face` in `assets/css/main.css` with `font-display: swap`.
  Total font payload is ~190 KB. Because the body face is already monospace, code
  blocks and inline code share the same family (with a system-monospace fallback
  stack), reinforcing the terminal-like feel.
- **Frills:** None. Minimal, restrained styles with subtle transitions (e.g. gentle
  hover states and the section-link icon fade-in). No animations beyond that.
- **Measure / max width:** Body content is constrained to a narrow,
  terminal-emulator-like measure of roughly **80 characters** wide. Since the body
  font is monospace this maps cleanly to a `ch`-based width, horizontally centered
  with comfortable side padding on small screens. This width applies to text;
  full-bleed-ish figures may use the full measure but not exceed it.
- **Responsiveness:** The single-column, fixed-measure layout is inherently
  mobile-friendly; verify it degrades gracefully below the content width with
  appropriate padding.

### Landing Page (`content/_index.md`)

Top-of-page header, then free-form Markdown body.

- **Header block:**
  - The club logo (a square mark rendered centered).
  - Name (Notre Dame Linux User Group).
  - A row of icon links to community/contact profiles (see below).
  - A clear hyperlink to the meetings log (`/meetings/`).
- **Body:** Standard Markdown sections authored in `_index.md` — About, how to get
  involved, and the **semester schedule as a Markdown table**. Authoring these is
  just editing the Markdown.

**Community / contact icon links (in header):**
- GitHub
- Email (`mailto:` list/contact address)
- IRC
- Matrix
- Mastodon

URLs for each are configured in `hugo.toml` site params so the template can render
the icon row from data. Icons are inline SVGs (self-hosted, no icon CDN), with
accessible `aria-label`s. The Mastodon (and other) profile links carry `rel="me"`
for identity verification.

### Meetings

A meeting is a blog-like post holding that session's notes and materials.

Features:
- **Section anchor links:** Each heading (h2–h…) gets a link/anchor icon that is
  hidden by default and fades in on hover of the heading. Clicking it copies the
  fully-qualified section URL to the clipboard (with a brief visual confirmation).
  Implemented with a small, progressively-enhanced script; the underlying anchor
  still works without JS.
- **RSS feed:** Meetings are published to an RSS feed (see RSS).
- **Syntax highlighting:** Code blocks use the **GitHub** highlighting palette —
  GitHub *light* in light mode and GitHub *dark* in dark mode — via Hugo's built-in
  Chroma highlighter with classes (`markup.highlight.noClasses = false`). Two
  generated stylesheets are gated by `prefers-color-scheme` so highlighting tracks
  the device theme without JS; the code-block background is overridden in `main.css`
  to match the site's navy/cream surfaces.
- **Listing order:** The meetings listing is sorted by **date**, newest first.

LaTeX/math rendering is intentionally **not** supported — it isn't needed for this
site, and leaving it out keeps the Markdown pipeline and dependencies minimal.

**Meeting front-matter metadata** (defined per meeting in `index.md`, templated by
`archetypes/meeting.md`):

| Field         | Type        | Notes                                              |
|---------------|-------------|----------------------------------------------------|
| `title`       | string      | Meeting title / topic.                             |
| `description` | string      | Short summary; used in listing and `<meta>` tags.  |
| `presenters`  | list        | One or more presenter names.                       |
| `date`        | datetime    | Date the meeting was held (sort order and feed).   |
| `lastmod`     | datetime    | Modified date. Authored in front matter (not Git). |
| `tags`        | list        | Drives tag chips and tag taxonomy pages.           |

Derived (not authored):
- **Reading time:** Computed automatically by Hugo (`.ReadingTime`) and displayed as
  e.g. "6 min read".

**Where metadata is shown:**
- **On the meetings listing:** title, description, date, reading time, presenters,
  and tag chips for each entry. The **description trails off** (truncated with an
  ellipsis via CSS line-clamp) when it's too long for the listing.
- **On the meeting header:** the same metadata displayed at the top of the meeting
  itself.

**Tags:**
- Tags render as **chips**. Each chip links to that tag's taxonomy page.
- Tag taxonomy is enabled in Hugo so `/tags/` lists all tags and `/tags/<tag>/`
  lists every meeting carrying that tag (sorted by date, newest first).

## RSS

- Generate an RSS 2.0 feed using Hugo's built-in RSS output for the `meetings`
  section (and/or the site root). The canonical feed URL is linked from the
  `<head>` via `<link rel="alternate" type="application/rss+xml">` and surfaced
  visibly on the meetings listing.
- Feed items are ordered by date (newest first) and include title, link,
  description, publish date, and author.

## Build, Hosting & Deployment

- **Build:** `hugo --minify` produces the static site into `public/`.
- **GitHub Pages:** The site is served by GitHub Pages directly from the artifact
  produced by the build workflow — there is no separate hosting config file to
  maintain. Hugo asset fingerprinting (via Hugo Pipes) gives fingerprinted CSS/JS
  stable, cacheable URLs; GitHub Pages applies its own default caching. A custom
  `404.html` is emitted by Hugo and served by Pages for not-found paths.
- **Base URL:** GitHub Pages serves a project site at
  `https://<owner>.github.io/<repo>/` (note the repository sub-path) unless a
  **custom domain** or an **`<owner>.github.io` user/org repo** is used, which serve
  at the domain root. `baseURL` in `hugo.toml` **must** match whichever applies so
  canonical/OG URLs, the RSS feed, and asset paths resolve correctly. Until the
  final URL is decided, keep `baseURL` as a clearly-marked placeholder. If a custom
  domain is used, add a `CNAME` file (a `static/CNAME` containing the domain works)
  so Pages keeps the mapping across deploys.
- **CI/CD (`.github/workflows/deploy.yml`):** On push to `main`, using GitHub's
  first-party Pages actions:
  1. Check out the repo.
  2. Install the pinned Hugo version (standard edition) via
     [peaceiris/actions-hugo](https://github.com/peaceiris/actions-hugo).
  3. `actions/configure-pages` (optionally injecting the resolved base URL).
  4. `hugo --minify`.
  5. `actions/upload-pages-artifact` (uploads `public/`), then a `deploy` job runs
     `actions/deploy-pages` with the `pages` permission and environment.
  - Optionally run build-only checks (e.g. `hugo` with `--printPathWarnings`) on
     pull requests without deploying.
  - No deploy secrets are required: Pages deploys authenticate via the workflow's
    `GITHUB_TOKEN` with `pages: write` / `id-token: write` permissions. Enable Pages
    for the repo with **Source: GitHub Actions** in the repository settings.

## Accessibility & SEO (baseline)

- Semantic HTML, single `<h1>` per page, logical heading order, alt text on figures.
- Per-page `<title>`, meta description, canonical URL, and Open Graph / Twitter card
  tags generated from front matter.
- `robots.txt` and an auto-generated `sitemap.xml` (Hugo built-in).
- Sufficient color contrast in both light and dark palettes.

## Implementation

This section is the map for future maintenance: where each feature lives, how it
works, and the upstream docs to read when you need to change it. Hugo's
[template lookup order](https://gohugo.io/templates/lookup-order/) explains *why*
each template file is named the way it is — skim it first if a template isn't being
picked up.

### Configuration ([hugo.toml](hugo.toml))

Single source of site-wide settings. Key blocks:

- `baseURL`, `title`, `copyright` — site identity. `baseURL` **must** be the final
  domain for canonical/OG URLs and the RSS feed to be correct.
- `enableGitInfo = false` — we deliberately do **not** use Git for dates. See
  [front-matter date config](https://gohugo.io/content-management/front-matter/#dates).
- `[frontmatter] lastmod = ["lastmod", ...]` — resolves "modified date" from the
  `lastmod` field, never from Git history.
- `[taxonomies] tag = "tags"` — enables the tag system
  ([taxonomies docs](https://gohugo.io/content-management/taxonomies/)).
- `[pagination] pagerSize = 10` — meetings per page on the listing
  ([pagination docs](https://gohugo.io/templates/pagination/)).
- `[[params.social]]` — ordered array of `{name, label, url}` for the header icons.
  `name` must match a key in [social-icon.html](layouts/partials/social-icon.html).
- `params.logoImage` — path (under `assets/`) to the club logo shown in the header.
- `[markup.goldmark.renderer] unsafe = true` — allows raw HTML in Markdown (needed
  for hand-written figures/captions). We author all content, so this is safe.
- `[markup.highlight] noClasses = false` — emit CSS **classes** (not inline styles)
  so we can theme code blocks ourselves
  ([syntax highlighting docs](https://gohugo.io/content-management/syntax-highlighting/)).

### Templates & the render pipeline

Hugo assembles every page from [baseof.html](layouts/_default/baseof.html) (the HTML
skeleton) plus a `{{ block "main" }}` body supplied by a more specific template:

| Page kind | Template | Notes |
|-----------|----------|-------|
| Landing | [layouts/index.html](layouts/index.html) | Logo header + Markdown body |
| Meeting | [layouts/_default/single.html](layouts/_default/single.html) | One leaf page |
| Meetings listing | [layouts/meetings/list.html](layouts/meetings/list.html) | `/meetings/`, paginated, newest-first |
| Tag index | [layouts/_default/taxonomy.html](layouts/_default/taxonomy.html) | `/tags/` |
| Single tag | [layouts/_default/term.html](layouts/_default/term.html) | `/tags/<tag>/` |
| Not found | [layouts/404.html](layouts/404.html) | Served by GitHub Pages |

The `<head>` is built in [head.html](layouts/partials/head.html); the footer in
[footer.html](layouts/partials/footer.html). Reusable fragments are
[partials](https://gohugo.io/templates/partial/):
[social.html](layouts/partials/social.html),
[social-icon.html](layouts/partials/social-icon.html),
[article-card.html](layouts/partials/article-card.html),
[article-meta.html](layouts/partials/article-meta.html), and
[tags.html](layouts/partials/tags.html). (The two `article-*` partials keep their
generic names — they render a "meeting" card/meta row but the code is content-type
agnostic.)

### Markdown render hooks ([layouts/_default/_markup/](layouts/_default/_markup/))

[Render hooks](https://gohugo.io/render-hooks/) let us override how specific Markdown
elements become HTML, so authors write plain Markdown and get our custom output:

- [render-heading.html](layouts/_default/_markup/render-heading.html) — wraps every
  heading with `id` + a hover-revealed anchor link. See
  [heading render hooks](https://gohugo.io/render-hooks/headings/) for the available
  context fields (`.Anchor`, `.Level`, `.Text`).
- [render-image.html](layouts/_default/_markup/render-image.html) — turns
  `![alt](file "caption")` into a `<figure>`, resolving bundle-relative image paths
  via `.Page.Resources.GetMatch`. See
  [image render hooks](https://gohugo.io/render-hooks/images/) and
  [page resources](https://gohugo.io/methods/page/resources/).

### Styling pipeline (plain CSS)

No SCSS/Sass — styles are hand-written plain CSS in [assets/css/](assets/css/).
[head.html](layouts/partials/head.html) bundles them through
[Hugo Pipes](https://gohugo.io/hugo-pipes/): `resources.Get` the two files →
[`resources.Concat`](https://gohugo.io/functions/resources/concat/) into one
`bundle.css` → `minify` →
[`fingerprint`](https://gohugo.io/functions/resources/fingerprint/) (content-hashed
filename + Subresource Integrity hash). None of these steps need Hugo extended. The
hashed name means the CSS URL changes whenever its contents do, so it caches cleanly.

The two source files:

- [main.css](assets/css/main.css) — `@font-face` declarations, design tokens, and all
  layout/component styles.
- [chroma.css](assets/css/chroma.css) — GitHub code colors: the light palette applied
  by default, the dark palette wrapped in `@media (prefers-color-scheme: dark)` so it
  overrides on dark devices. The code-block background is overridden in `main.css` to
  match the site surfaces.

Design tokens (palette, fonts, the `--measure` width) are CSS custom properties at
the top of `main.css`, with a `@media (prefers-color-scheme: dark)` block overriding
the palette. Reference:
[prefers-color-scheme (MDN)](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme),
[CSS custom properties (MDN)](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties).

### Fonts ([static/fonts/](static/fonts/), `@font-face` in [main.css](assets/css/main.css))

Self-hosted **Commit Mono** (Latin subset `woff2`, weights 400/500/700 + 400 italic),
served from `static/` at stable `/fonts/...` URLs (so the `@font-face` `url()` paths
don't change and can be cached for a year). The files came from
[Fontsource](https://fontsource.org/fonts/commit-mono) (`@latest` Latin subset). To
refresh or add a weight, re-download the corresponding `woff2` and add a `@font-face`
block. `font-display: swap` avoids invisible text while loading
([MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/font-display)).

### Syntax highlighting (GitHub)

Hugo's built-in [Chroma](https://github.com/alecthomas/chroma) highlighter runs at
build time and (with `noClasses = false`) emits `<span class="...">` tokens.
[chroma.css](assets/css/chroma.css) is generated from Chroma's built-in styles — the
light palette first, the dark palette wrapped in a media query:

```bash
{
  hugo gen chromastyles --style=github
  echo '@media (prefers-color-scheme: dark) {'
  hugo gen chromastyles --style=github-dark
  echo '}'
} > assets/css/chroma.css
```

To change the theme, pick a new style from the
[Chroma style gallery](https://xyproto.github.io/splash/docs/) and regenerate the
file. Reference:
[Hugo syntax highlighting](https://gohugo.io/content-management/syntax-highlighting/),
[`gen chromastyles`](https://gohugo.io/commands/hugo_gen_chromastyles/).

### Heading anchor links

Two pieces: [render-heading.html](layouts/_default/_markup/render-heading.html)
outputs the anchor markup, and [anchors.js](assets/js/anchors.js) (loaded `defer`,
minified + fingerprinted in [baseof.html](layouts/_default/baseof.html)) upgrades the
click to copy the absolute section URL via the
[Clipboard API](https://developer.mozilla.org/en-US/docs/Web/API/Clipboard/writeText).
It's [progressive enhancement](https://developer.mozilla.org/en-US/docs/Glossary/Progressive_Enhancement):
without JS the anchor still works as a normal in-page link. The hover-reveal and
`.copied` confirmation states are styled in `main.css`.

### Listing, metadata, tags & reading time

- [list.html](layouts/meetings/list.html) sorts with `.Pages.ByDate.Reverse`, paginates
  via `.Paginate`, and renders each entry with
  [article-card.html](layouts/partials/article-card.html). Pagination UI uses Hugo's
  `_internal/pagination.html`.
- [article-meta.html](layouts/partials/article-meta.html) prints presenters · date ·
  "Updated …" (only when `lastmod`'s date differs from `date`) · reading time.
  Reading time is Hugo's [`.ReadingTime`](https://gohugo.io/methods/page/readingtime/).
- [tags.html](layouts/partials/tags.html) renders chips linking to
  `/tags/<urlized>/`. The description "trail off" on cards is CSS
  [`line-clamp`](https://developer.mozilla.org/en-US/docs/Web/CSS/-webkit-line-clamp)
  in `main.css`.

### RSS & `<head>`/SEO

RSS comes free from Hugo's [output formats](https://gohugo.io/templates/output-formats/):
the home and section pages emit `index.xml`
([RSS templates](https://gohugo.io/templates/rss/)). [head.html](layouts/partials/head.html)
auto-discovers it by ranging `.AlternativeOutputFormats` to emit the
`<link rel="alternate" type="application/rss+xml">`, and also sets the canonical URL,
description, Open Graph, Twitter card, theme-color (light/dark), and favicon.

### Content authoring & front matter

Content lives in [content/](content/) as
[page bundles](https://gohugo.io/content-management/page-bundles/): each meeting is a
folder with `index.md` and its own figures/materials. New meetings are scaffolded from
[archetypes/meeting.md](archetypes/meeting.md) (`draft = true` by default). Front
matter fields are documented in the table under [Meetings](#meetings).

### Build & deploy

- **Local:** `hugo server` (live reload) or `hugo --minify` (production → `public/`).
- **CI:** [.github/workflows/deploy.yml](.github/workflows/deploy.yml) reads
  [.hugo-version](.hugo-version), installs Hugo via
  [peaceiris/actions-hugo](https://github.com/peaceiris/actions-hugo), builds, then
  publishes with GitHub's first-party Pages actions
  ([configure-pages](https://github.com/actions/configure-pages),
  [upload-pages-artifact](https://github.com/actions/upload-pages-artifact),
  [deploy-pages](https://github.com/actions/deploy-pages)) on push to `main`.
- **Hosting:** [GitHub Pages](https://docs.github.com/en/pages) serves the uploaded
  `public/` artifact. No hosting config file is required; the repo must have Pages
  enabled with **Source: GitHub Actions**. A custom domain, if any, is set via a
  `CNAME` file and the repository's Pages settings.

### Maintenance cookbook

- **Add a meeting:** `hugo new meetings/<slug>/index.md`, fill front matter, set
  `draft = false`, drop figures/slides in the same folder.
- **Edit the schedule:** update the Markdown table in
  [content/_index.md](content/_index.md).
- **Add/replace a community link:** add a `[[params.social]]` entry in `hugo.toml`; if
  it's a new platform, add its `name`→SVG path in
  [social-icon.html](layouts/partials/social-icon.html) (brand glyphs from
  [Simple Icons](https://simpleicons.org/)).
- **Swap the logo:** replace `assets/images/logo.svg` (or point `params.logoImage`
  at a new file).
- **Tweak colors:** edit the `:root` and dark-mode custom properties in
  [main.css](assets/css/main.css).
- **Change the code theme:** regenerate [chroma.css](assets/css/chroma.css) (see
  Syntax highlighting).
- **Change the body width:** edit `--measure` in [main.css](assets/css/main.css).
- **Change fonts:** swap the `woff2` files in `static/fonts/` and update the
  `@font-face` blocks in [main.css](assets/css/main.css).
- **Bump Hugo:** update [.hugo-version](.hugo-version) (CI reads it); rebuild locally
  to catch deprecations.

## Open Questions / To Be Decided

- Final **site URL**: a project site under `https://<owner>.github.io/<repo>/`, an
  `<owner>.github.io` user/org site, or a **custom domain** — then set `baseURL` in
  `hugo.toml` (and add a `CNAME` if using a custom domain) to match.
- Confirm the repository has **Pages enabled with Source: GitHub Actions**.
- Exact community profile URLs (GitHub, Email, IRC, Matrix, Mastodon) — currently
  placeholders in `hugo.toml`.
- The real **club logo** to replace the placeholder `assets/images/logo.svg`.
