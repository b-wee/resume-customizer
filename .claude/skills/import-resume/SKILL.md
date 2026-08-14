---
name: import-resume
description: Seed the master profile from an existing resume file (PDF, docx, or text). Use when the user wants to import, upload, or start from their current resume.
---

# Import an existing resume

Parse a resume file into the `profile/` structure, then offer to enrich it.

## Process

1. **Get the file.** Ask for a path if not provided (they can drag the file into the chat). Read it with the Read tool (works for PDF directly; for .docx use `pandoc <file> -t markdown` or the docx skill).
2. **Map content into profile files:**
   - Header → `profile/contact.md` (name, email, phone, location, links)
   - Summary/objective → `profile/summary.md`
   - Each work experience entry → `profile/jobs/YYYY-company-role.md` with frontmatter (company, title, location, start, end) and the resume's bullets verbatim under `# Raw description`
   - Education → `profile/education.md`
   - Skills/certifications → `profile/skills.md`
3. **Protect existing content.** If a profile file already has real (non-placeholder) content, show a diff of what you'd change and ask before touching it. New job files are safe to create; matching existing job files get appends, not overwrites.
4. **Show the import summary**: which files were created/updated, and which resume content you weren't sure where to put (ask, don't drop).
5. **Offer enrichment.** Resume bullets are compressed; the profile wants the uncompressed story. Offer to go job-by-job asking the /add-job style probes (impact numbers, scope, tools, proud moments). Append answers under `## Follow-up detail (added YYYY-MM-DD)`. The user can stop anytime — partial enrichment is fine.
6. **Commit**: `git add profile && git commit -m "Import resume from <filename>"`.

## Rules

- Verbatim capture: the resume's own wording goes in as-is; do not paraphrase during import.
- Never invent dates/companies from ambiguous text — ask.
