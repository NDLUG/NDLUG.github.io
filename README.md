# Notre Dame Linux User Group — website

A statically rendered club site built with [Hugo](https://gohugo.io/) and a
custom theme, deployed to GitHub Pages. See [DESIGN.md](DESIGN.md) for the
full design.

## Develop

Requires **Hugo** (version pinned in [.hugo-version](.hugo-version)).

```bash
hugo server      # live-reload dev server at http://localhost:1313
hugo --minify    # production build into ./public
```

## Add content

Everything is Markdown under `content/`.

- **Landing page:** edit [content/_index.md](content/_index.md) — the About
  section and the semester schedule table both live here.
- **New meeting:** `hugo new meetings/my-meeting/index.md`, then set
  `draft = false`. Put figures/slides (e.g. `figure0.webp`) alongside `index.md`
  in the same folder and reference them with `![alt](figure0.webp "Caption")`.

Meeting front matter: `title`, `description`, `date` (held), `lastmod`
(modified — read from front matter, **not** Git), `presenters`, `tags`. Reading
time is computed automatically.

## Deploy

Pushing to `main` builds and deploys to **GitHub Pages** via
[.github/workflows/deploy.yml](.github/workflows/deploy.yml). One-time setup:
enable Pages for the repo under **Settings → Pages → Build and deployment →
Source: GitHub Actions**, and set `baseURL` in [hugo.toml](hugo.toml) to the
site's final URL (a project site lives at `https://<owner>.github.io/<repo>/`; a
custom domain or `<owner>.github.io` repo serves at the root — add a `CNAME` for a
custom domain). No deploy secrets are needed; the workflow uses `GITHUB_TOKEN`.
