# Changes and review

Use these rules when creating or reviewing code, planning large generated changes, or organizing pull requests.

Do not describe AI-assisted code as approved or ready to merge until a human has reviewed it.

## Repository-specific guidance

Apply these files when present:

- `REVIEW.md` for testing, code quality, commit messages, and commit organization.
- `REVIEW_RUST.md` for Rust changes.
- `REVIEW_GOLANG.md` for Go changes.

## Review pass

Before declaring a non-trivial code task complete, use a subagent, when available, to review the change for correctness, regressions, missing tests, and violations of applicable repository guidance. Apply the same guidance when reviewing someone else's code.

## Large generated changes

If a proposed change would add more than approximately 500 substantial non-whitespace lines of generated code, encourage the human to seek design review through an issue before implementation.

## Pull-request organization

Separate independently reviewable preparatory work from the main change. When a pull request has been requested and the repository is hosted on GitHub, use stacked pull requests when that makes the review sequence clearer.
