# Debugging

Before changing behavior to fix a bug:

1. Reproduce the failure or establish another observable signal.
2. Gather evidence about the suspected root cause.
3. If the evidence is insufficient, form competing hypotheses and add the smallest temporary instrumentation needed to distinguish them.
4. Change behavior only when the evidence supports the proposed fix. Clearly label mitigations or diagnostic changes that do not address a confirmed root cause.
5. Remove temporary instrumentation and add a regression test. If a regression test is impractical, explain why.

If the failure cannot be reproduced or isolated, report the remaining uncertainty instead of presenting a speculative change as a confirmed fix.
