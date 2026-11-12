# Spec Review

## Simplify First, Then Polish the Prose

1. Cut what the first version does not need: a feature whose input produces nothing yet, two sources for the same fact, or a step that only exists to keep duplicates in sync.
2. Treat TODOs, unanswered questions, undecided alternatives, and unspecified required behavior as open items. Propose the simplest workable default for each one, mark each default you chose, and apply it only after the user agrees.
3. Look for contradictions: the same thing modeled twice, a rule that has no effect under another rule, or terms used but never defined.
4. Report how many physical Markdown lines and open items the specification had before and after the rewrite.

## Make It Easy to Read

When the specification defines a command, file format, or rule system:

- Explain its inputs and outputs, with one representative command and result.
- Show one complete file example before reference material.
- Use tables for rule mappings when a table makes the behavior easier to compare.

## Keep Decisions Visible

- When a specification builds on another document, such as a design note or PRD, state which one is authoritative. List every intentional change in meaning or scope in a table with `before`, `after`, and `why` columns.
- Separate decisions the user made from decisions you made. Present your decisions first as yes-or-no questions.

## Deliver for Review

- Review with the user before rewriting. Present decisions requiring confirmation first, followed by proposed cuts, contradictions, and prose issues. Rewrite only after the user agrees.

## Vendor-Specific Guidance

### Claude

A private review artifact is visible to the user but is not published externally.

- In Claude environments that support private artifacts, publish one for every initial specification review, including review-only requests, before making changes. Include decisions to confirm, proposed cuts, contradictions, and prose issues.
- Review the artifact with the user and wait for agreement before rewriting.
- After an agreed rewrite, update the artifact with three views: review notes covering what was agreed, what changed, and what remains open; the revised specification; and the source specification.
- When private artifacts are unavailable, write the same review to a Markdown file and provide its path.
- If the source specification lives outside the session's writable folders, write the revised specification inside them and provide its path.
