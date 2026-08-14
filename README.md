# Resume Customizer

Tailor your resume to any job posting using [Claude Code](https://claude.com/claude-code) —
free with your existing Claude subscription, no API keys, no external services.

You maintain one **master profile**: plain Markdown files describing everything
you've ever done, in as much detail as you like. For each job posting, Claude
reads your whole profile, picks the most relevant facts, rewrites them in the
posting's vocabulary, and renders a one-page ATS-safe resume as PDF, Word, and
plain text. Anything the posting asks for that your profile can't back up goes
into a **gap report** as questions to you — nothing is ever invented.

## How it works

1. Your Claude Code session *is* the intelligence. All the logic lives in
   project skills under `.claude/skills/` — instructions Claude follows when
   you invoke a slash command.
2. Your career history lives in `profile/` as freeform Markdown. Raw job
   descriptions are append-only: the tool never rewrites or deletes your words,
   so the profile only ever gets richer.
3. Each tailoring run is reviewed by you in chat before anything is rendered,
   then saved to its own dated folder in `output/`.

## Requirements

- [Claude Code](https://claude.com/claude-code)
- Google Chrome (used headless for PDF rendering)
- [pandoc](https://pandoc.org) (for .docx output): `brew install pandoc`

## Quickstart

Clone this repo, open the folder in Claude Code, then:

1. **Seed your profile** (once):
   - Have a resume? `/import-resume` and point at the file.
   - Or describe jobs conversationally: `/add-job`.
   - Fill in `profile/contact.md` (name, email, phone, location, links).
2. **Enrich over time:** `/update-job` whenever you remember more detail about
   a past role. More raw detail = better tailored resumes. Nothing you write
   is ever put on a resume unedited, and nothing is ever deleted.
3. **Tailor:** `/tailor <job posting URL>` — or just `/tailor` and paste the
   posting text. Review the draft and gap report in chat, approve, and get
   PDF + Word + plain text in `output/`, named like
   `Jane-Doe_Resume_Acme_Senior-Engineer.pdf`.
4. **Find past resumes:** `/list-resumes`.

## Where files go

```
profile/                  your master profile (yours to edit, grows over time)
  contact.md              name, email, phone, location, links
  summary.md              elevator pitch / positioning
  skills.md               everything you can do
  education.md            degrees, certifications
  jobs/                   one file per past job, freeform detail
    2021-acme-senior-engineer.md
templates/resume.html     ATS-safe single-column template ({{PLACEHOLDER}} slots)
scripts/render.sh         HTML → PDF + docx + txt
output/                   one folder per tailoring run
  2026-08-14_acme_senior-engineer/
    Jane-Doe_Resume_Acme_Senior-Engineer.pdf / .docx
    resume.txt            plain text for copy-paste into forms
    resume.html           the filled template
    job-posting.md        the posting you tailored to
    gap-report.md         what the posting wanted that your profile lacked
docs/fixtures/            fake profile + sample posting for trying the tool
```

## How it stays honest

Every bullet traces back to something you actually wrote in `profile/`. When a
posting wants something your profile doesn't cover, you get a gap report asking
whether you have that experience — answer once and it's saved to your profile
for all future resumes.

## Privacy note

`profile/` and `output/` will contain your personal information. If you push
your copy of this repo anywhere, **make it a private repository** (or add
`profile/` and `output/` to `.gitignore`).

## Try it without your own data

`docs/fixtures/` contains a fake profile (Jordan Sample) and a sample posting.
Ask Claude to run a tailoring pass against the fixtures to see the output
format before committing your own history.
