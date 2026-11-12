# Atlassian Workflow

Create or modify Jira and Confluence content only when explicitly requested.

- Use the authenticated Atlassian CLI, `acli`, for Atlassian operations.
- Command reference: https://developer.atlassian.com/cloud/acli/reference/commands/. Jira commands live under `acli jira` (`board`, `field`, `filter`, `project`, `sprint`, `workitem`, `dashboard`, `auth`).
- If `acli` is unavailable or fails, use the configured Atlassian MCP server.
