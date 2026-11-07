# AI attribution and signoff

Use these rules when committing AI-assisted work, handling DCO checks, or describing AI assistance.


## DCO signoff

Agents must not add a `Signed-off-by` trailer. A signoff is a human attestation and must be added through explicit human action.

If a requested pull request fails a DCO check:

1. Tell the human to review the code.
2. Explain how they can add the signoff themselves, for example with `git commit --amend --signoff`.

## AI disclosure

For commits containing substantial AI assistance, add `Assisted-by: AI`. For effectively AI-generated commits, add `Generated-by: AI`.

Do not add `Co-developed-by` or name specific models or tools.

For new contributors, include a brief statement in the requested pull-request description describing the human reviewer's familiarity and level of review. Examples:

> Assisted-by: AI  
> Unit tests are LLM generated.

> Generated-by: AI  
> I am knowledgeable in this problem domain and reviewed it carefully.

> Generated-by: AI  
> I do not know this language well, but I tested the change and confirmed that it fixed the problem.
