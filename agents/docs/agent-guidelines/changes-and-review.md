# Changes and review

Use these rules when creating or reviewing code, planning large generated changes, or organizing pull requests.

## Repository-specific guidance

Before changing or reviewing code, read the repository's `README.md` and any contribution guidance it points to, including `CONTRIBUTING.md` when present.

Apply these files when present:

- `REVIEW.md` for testing, code quality, commit messages, and commit organization.
- `REVIEW_RUST.md` for Rust changes.
- `REVIEW_GOLANG.md` for Go changes.

## Review pass

After each commit, and before declaring a task complete, use a subagent to review the change against the applicable review guidance and look for other issues. Apply the same guidance when reviewing someone else's code.

## Large generated changes

If a proposed change would add more than approximately 500 substantial non-whitespace lines of generated code, encourage the human to seek design review through an issue before implementation.

## Pull-request organization

Separate independently reviewable preparatory work from the main change. When a pull request has been requested and the repository is hosted on GitHub, use stacked pull requests when that makes the review sequence clearer.
