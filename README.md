# Notre Dame Linux User Group — website

> This document authored by Claude, edited by Sam. Be careful out there.

A statically rendered club site built with [Hugo](https://gohugo.io/) and a
custom theme, deployed to GitHub Pages. See [DESIGN.md](DESIGN.md) for the
full design.

## Develop

Install Hugo:
```zsh
brew install hugo
```

Run the dev server:
```bash
hugo server      # live-reload dev server at http://localhost:1313
```

## Add content

With Hugo, the site layout is based on the files and directories in `content/`. The pages are the `index.md` files.

To adjust the:
- **Landing page:** edit [content/_index.md](content/_index.md) — the About
  section and the semester schedule table both live here.
- **Meeting writeups:** Run `hugo new meetings/my-meeting/index.md`, then set
  `draft = false`. Put figures/images (e.g. `figure0.webp`) alongside `index.md`
  in the same folder and reference them with `![alt](figure0.webp "Caption")`. The stuff wrapped in `+++` at the top of the document is called "front matter", and describes metadata for the page. Besides that, everything is just plain markdown.

## Deploy

Pushing to `main` builds and deploys to **GitHub Pages** via
[.github/workflows/deploy.yml](.github/workflows/deploy.yml).