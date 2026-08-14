---
name: update-job
description: Append new detail to an existing job in the master profile. Use when the user remembers more about a past role or wants to enrich a job description.
---

# Update a job in the master profile

Append detail to an existing `profile/jobs/*.md` file. Never delete or rewrite what's there.

## Process

1. List files in `profile/jobs/` and ask which job to update (skip asking if they already named it, or if there's only one).
2. Read the file and show a brief recap of what's already captured, so they don't repeat themselves.
3. Ask what they'd like to add. Accept any form — prose, bullets, fragments.
4. Optionally probe once or twice for numbers/scope/tools if the addition is thin (same style as /add-job).
5. Append under a dated heading at the end of the file:

```markdown
## Added YYYY-MM-DD

<their words, verbatim>
```

6. If frontmatter facts changed (e.g. an end date — they left the job), update the frontmatter only.
7. Commit: `git add <file> && git commit -m "Update job: <Company>"`.

## Rules

- Existing text is immutable. Additions only.
- Contradictions (e.g. "actually it was $2M not $1M"): append the correction with a note, and mark the old figure with `<!-- superseded, see below -->` rather than deleting.
