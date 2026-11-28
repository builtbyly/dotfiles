# Command-Line Tooling

Use harness-native search, file-reading, and editing tools when available.

When terminal commands are appropriate, prefer:

- `rg` over `grep` for searching file contents.
- `fd` over `find` for interactive file discovery.
- `sd` over `sed` for straightforward literal or regular-expression replacements.
- `jq` for reading or transforming JSON.
- `yq` for reading or transforming YAML.

Use the standard tool when:

- the preferred tool is unavailable;
- portability is part of the task;
- the command belongs in a script intended for environments where the preferred tool is not guaranteed;
- the standard tool expresses the operation more clearly or safely.

Before relying on a non-standard command in a persistent script, verify that the repository documents it as a dependency.
