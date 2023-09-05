# NDLUG.github.io

Source for [ndlug.org](https://ndlug.org), made with <3.

No tracking, bloat, or javascript.

For suggestions and fixes, create an issue or email `ndlug@nd.edu`.

## Requirements

- [coreutils](https://www.gnu.org/software/coreutils/)
- [pandoc](https://pandoc.org/)

## Building

To build the website, simply run `make`.  This will generate the website
(including [RSS] feed) and put it in the `docs` folder.

## Testing

If you wish to view a local copy of the website, you can use [Python]'s builtin
[http.server] module:

    python3 -m http.server --directory docs 
    
You should then view the website in your web browser at the specified host and
port.

[Python]: https://www.python.org/
[http.server]: https://docs.python.org/3/library/http.server.html

## Blog Posts

To create a new **blog post**, add a new [markdown] file in the `content`
folder with the following file name format:

    content/YYYY-MM-DD-post-title.md
    
At the top of each post is the following meta-data:
    
    ---
    title: Post Title
    date: YYYY-MM-DD
    author: Full Name
    ---
    
Below this are the contents of the blog post written in [markdown] or [HTML].

## Assets

New assets such as images go in the `docs/assets/img` folder.  When possible,
adhere to the `YYYY-MM-DD-image-description.jpg` format.

[markdown]: https://en.wikipedia.org/wiki/Markdown
[HTML]:     https://developer.mozilla.org/en-US/docs/Web/HTML
[RSS]:      https://en.wikipedia.org/wiki/RSS
