+++
title = "Template"
description = "This is template meeting that you can copy."
date = 2026-01-01
lastmod = 2026-01-01
writers = ["Template Author"]
tags = ["Template"]
draft = true
+++

## Hugo

This website is build using [Hugo](https://gohugo.io/). Hugo is a framework that constructs
a static website from a directory tree containing folders, Markdown files, and images.

Start the dev server:

```zsh
hugo server --buildDrafts
```

## Front matter

The stuff wrapped `+++` at the top of these documents is called "front matter".
It contains metadata about the post that is used when Hugo renders the website.
Please update it, but leave `draft = true` alone. The maintainers will update
this to true before your changes get merged to `main`.

## Markdown

After the front matter, the rest of the document is (kind of) regular ole'
Markdown. See [this Markdown guide](https://www.markdownguide.org/) if you are
unfamiliar with Markdown.

## Formatting

Run `make fmt` to quickly format your Markdown files. Please do this before you
make any commits.

## Figures

To insert a figure: [Add alt text in the brackets](image.webp)

Make sure the image file is in the same directory as this `index.md` file.

## Links and Cross References

To link to another page on this site, use Hugo's link syntax:
[Links and Cross References](https://gohugobrasil.netlify.app/content-management/cross-references/)

For example, to link to the LLM Disclosure, you would do this: [LLM
Disclosure]({{<ref "/#llm-disclosure">}})
