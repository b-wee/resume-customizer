---
name: add-job
description: Capture a new past job for the master profile through a natural conversation. Use when the user wants to add, describe, or record a job/role/position they held.
---

# Add a job to the master profile

Capture one job into `profile/jobs/` preserving everything the user says verbatim.

## Process

1. **Ask for the basics** (one message): company, job title, location, start/end dates (month/year; "present" is fine).
2. **Ask them to describe the job** in whatever form they like — vague or excruciating detail, prose or bullets. Tell them: "More detail is always better; nothing is wasted and nothing goes on a resume unedited."
3. **Probe with follow-ups** (2-4 questions max, one message at a time) targeting what makes strong bullets, where their description is thin:
   - Impact and numbers: revenue, users, scale, percentages, time saved, money saved
   - Scope: team size, who they led/mentored, what they owned
   - Tools and technologies used
   - Anything they're proud of that they didn't mention
   Stop probing when they signal they're done — don't interrogate.
4. **Save the file** as `profile/jobs/YYYY-company-role.md` (YYYY = start year; slug company and role, lowercase, hyphens):

```markdown
---
company: <Company>
title: <Title>
location: <Location>
start: YYYY-MM
end: YYYY-MM | present
---
# Raw description

<everything the user wrote, verbatim — their words, their structure>

## Follow-up detail (added YYYY-MM-DD)

<their answers to your probes, verbatim or lightly cleaned, never summarized away>
```

5. **Confirm** what was saved and remind them: `/update-job` adds more detail anytime, `/tailor` uses it all.

## Rules

- NEVER rewrite, condense, or "improve" their raw description. Verbatim in, tailoring happens later per-resume.
- If a file for the same company+role exists, switch to update mode (append, don't overwrite).
- Commit the new file to git after saving: `git add profile/jobs/<file> && git commit -m "Add job: <Company> <Title>"`.
