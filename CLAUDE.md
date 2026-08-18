# Resume Customizer

Personal resume tailoring tool. The Claude session is the LLM — no API keys.
All intelligence lives in the project skills under `.claude/skills/`.

## Layout

- `profile/` — master profile, human-editable Markdown. `jobs/` has one file per
  past job with frontmatter (company, title, location, start, end) and a
  freeform `# Raw description`. **Raw descriptions are append-only: never
  rewrite, condense, or delete the user's words.** `preferences.md` holds the
  user's style rules; it overrides the tailor skill's defaults.
- `templates/resume.html` — ATS-safe single-column template with `{{PLACEHOLDER}}`
  slots; block structures documented in its HTML comments.
- `scripts/render.sh <output-dir> <basename>` — renders `<output-dir>/resume.html`
  to PDF (headless Chrome), docx (pandoc), and resume.txt.
- `output/YYYY-MM-DD_company_role/` — one folder per tailoring run, files named
  `First-Last_Resume_Company_Role.*`. Versioned in git; never overwrite a run,
  append `-v2`.
- `docs/fixtures/` — fake profile + sample posting for smoke-testing.

## Skills

`/import-resume` (seed profile from existing resume) · `/add-job` · `/update-job`
· `/tailor <url or pasted posting>` (the main event) · `/list-resumes`

## Iron rule: truthfulness

Tailored resumes may only rephrase, select, and reorder facts present in
`profile/`. Never add a skill, number, or experience the profile doesn't
contain — posting requirements the profile can't back go in the gap report as
questions to the user.
