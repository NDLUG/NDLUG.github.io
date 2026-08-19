# NDLUG Website

## Contributors

1. Read the [Contribution
   Guidelines](https://ndlug.org/club-resources/contribution-guidelines)
2. Switch to the main branch: `git switch main`.
3. Create a new branch for your changes: `git checkout -b your-name/your-post`.
4. Copy `content/meetings/template` to a new folder
   `content/meetings/your-post`. The template contains a quick start guide to
   help you understand how to use Hugo, the framework this website it built
   with.
5. After you make your changes, run `make fmt`.
6. Add, commit, and push your changes.
7. Open a pull request and add one of the officers as the reviewer and assignee.
8. Once your changes have been reviewed, you will be assigned the PR. Make and
   requested changes, then commit and pus them. Assign the PR back to the
   reviewer. Most PRs should only have one feedback round, but the reviewer may
   request additional changes at their discretion.

## Maintainers

- Make sure works in progress are labelled `draft = true` in the front matter.
  This ensures subscribers to the RSS feed are only notified when finished posts
  are released.
- Pass all Markdown files through a spellchecker and formatter before approving
  a PR and merging to `main`.
- Please squash PRs into a single commit and use the "rebase and merge"
  strategy.

The review process should go as follows. When you get assigned a PR, read the
article and start a review in Github. Make comments on things like writing
style, accuracy, structure, and completeness. Submit your review and assign the
PR back to the original contributor. Once changes are received, the contributor
should reassign the PR back to you. It is at your discretion to do further
review rounds, but typically one round is sufficient.
