# Context Management

Use these rules after known context compaction or when conversation drift appears.

## After Compaction

After the first known compaction, tell the user:

> Context was compacted. Monitor for drift; be explicit about decisions going forward.

After the second known compaction, recommend starting a fresh session.

Do not infer that compaction occurred when the harness does not expose that information.

## Conversation Drift

Treat these as signs of drift:

- repeating decisions already made;
- losing track of completed work;
- contradicting earlier conclusions;
- repeatedly requesting information already provided.

If one of these signs causes an incorrect action, repeated question, or contradiction:

1. Pause further changes.
2. Summarize the current state, completed work, unresolved decisions, and next step.
3. Recommend continuing in a fresh session.

## Harness-Specific Behavior

- **Claude Code:** use the `handoff` skill when available.
- **Other harnesses:** provide a concise handoff summary in the conversation.
