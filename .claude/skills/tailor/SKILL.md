---
name: tailor
description: Generate a resume tailored to a specific job posting (URL or pasted text). Selects and rewrites bullets from the master profile, flags gaps, and renders PDF/docx/txt after user review.
---

# Tailor a resume to a job posting

Turn the master profile + a job posting into a targeted one-page resume, with a
review step before rendering.

## Step 1 — Capture the posting

- **URL given:** fetch with WebFetch. If it fails or returns a login wall (LinkedIn often does), ask the user to paste the posting text instead.
- **Stale-posting check:** if the fetch returns a 404, a "position closed/filled"
  notice, or a generic careers page instead of the specific posting, say so and
  ask for pasted text — never tailor to boilerplate.
- **Text given:** use it directly.
- Extract company name and role title (confirm with user if ambiguous).

## Step 2 — Analyze the posting

Extract and keep for later steps:
- Hard requirements (must-haves) and nice-to-haves
- Keywords and vocabulary the posting uses (exact phrasings matter for ATS)
- What the role actually emphasizes (leadership? scale? shipping speed? domain?)

## Step 3 — Read the whole profile

Read every file in `profile/` including all of `profile/jobs/` and
`profile/preferences.md` (the user's style rules — where it conflicts with the
defaults below, preferences.md wins). If `profile/jobs/` is empty or files are
placeholder-only, STOP and tell the user to run `/import-resume` or `/add-job`
first — do not generate a thin resume.

## Step 4 — Draft the tailored resume

### Selecting and writing bullets

- **Bullets:** For each job, select the profile facts most relevant to this
  posting and compress them into succinct, strong bullets (action verb, what,
  measurable impact). Mirror the posting's vocabulary **only where truthful**
  (profile says "Kafka", posting says "event streaming" → "event streaming
  (Kafka)" is fine; claiming Kubernetes because the posting wants it is not).
- **Quantify or cut:** prefer bullets with a number (%, growth multiple, time
  saved, scale, headcount, users, volume). If a strong-seeming bullet has no
  measurable outcome and no clear scope, note it in the gap report as a question
  ("Can you put a number on X?") rather than padding it with vague claims.
- **STRICT TRUTHFULNESS:** every claim must trace to something in the profile.
  No invented skills, numbers, or experiences. When unsure, leave it out and
  put it in the gap report.
- **Titles and dates verbatim:** job titles and dates come exactly from the job
  file frontmatter. Never upgrade a title toward the posting's seniority
  ("Engineer" does not become "Senior Engineer" because the posting is senior).
- **Order:** most relevant bullets first within each job; 3-5 bullets for recent/
  relevant roles, 1-3 for older/less relevant ones. Reverse-chronological jobs.
- **HARD CAP (default, see preferences.md): maximum 6 bullets per job.** If more
  than 6 bullets of genuinely relevant content exist, merge related ones and
  FLAG the overflow to the user during the review step (say what was merged or
  dropped and why), so they can veto the cuts.

### Writing style

- **Defaults (preferences.md can override):** no em-dashes and no semicolons
  anywhere in resume text. Use commas, periods, or parentheses instead. Avoid
  other AI-writing tells. Plain professional sentences only.
- **No first person:** never "I", "my", "we". Bullets start with the verb.
- **Strong verbs only:** ban "Responsible for", "Helped with", "Worked on",
  "Assisted with", "Participated in" — say what the person actually did. Ban
  buzzword filler ("results-driven", "detail-oriented", "synergy") in the
  summary.
- **Vary verbs:** no two consecutive bullets in a job start with the same verb.
- **Tense:** present tense for the current role, past tense for all others,
  consistently.
- **Plain characters:** no Unicode arrows, emoji, or decorative glyphs in
  resume text, even if the profile contains them (ATS parsers choke).

### ATS mechanics

- **Acronyms:** when the posting uses both the spelled-out and short form,
  include both on first use — "Technical Program Manager (TPM)" — so keyword
  matchers hit either.
- **Dates:** one consistent format throughout (e.g. "Jan 2021 – Mar 2023").
  Use months when the profile has them — year-only ranges read as gaps.

### Confidential information

- **Financials (default, see preferences.md):** never put absolute revenue,
  budget, or cost figures from private companies on a resume. Convey scale with
  percentages, growth multiples (15x), relative framings (8-figure), headcount,
  users, or volume instead. Publicly reported figures are allowed.

### Summary and skills

- **Summary:** 2-3 lines targeted at this role, distilled from `summary.md` +
  jobs. No buzzword filler.
- **Skills section:** only profile-listed skills, subset + ordering chosen for
  this posting.

## Step 5 — Gap report

List posting requirements (must-have and nice-to-have) that the profile does not
cover, each with: what the posting wants, and a question like "Do you have any
X experience I should add to your profile?" Include unquantified strong bullets
("Can you put a number on X?"). If the user supplies new experience, append it
to the relevant job file (dated heading, as in /update-job) and incorporate it —
the profile grows, the resume stays truthful.

## Step 6 — Review in chat

Present, in this order: proposed output name, the drafted resume content
(markdown), a **keyword coverage table** (the posting's top ~10 keywords, each
marked hit/miss against the draft, with a one-word reason for each miss —
"untrue" is a fine reason), and the gap report. Iterate until the user
approves. Also confirm length: if content clearly can't fit one page, propose
what to cut, or ask if two pages is acceptable.

## Step 7 — Render

1. Output folder: `output/YYYY-MM-DD_<company-slug>_<role-slug>/` (today's date).
   If it exists, append `-v2`, `-v3`, ….
2. File basename: `<First>-<Last>_Resume_<Company>_<Role>` (from contact.md,
   Title-Case, hyphens within parts, underscores between).
3. Fill `templates/resume.html` placeholders ({{NAME}}, {{CONTACT_LINE}},
   {{SUMMARY}}, {{EXPERIENCE}}, {{EDUCATION}}, {{SKILLS}}) using the block
   structures shown in the template's comments. Write to `<folder>/resume.html`.
4. Save `<folder>/job-posting.md` (captured posting text + source URL) and
   `<folder>/gap-report.md`.
5. **Consistency check before rendering:** name and contact line match
   `contact.md` exactly; every job's title/dates match its frontmatter; no
   `{{PLACEHOLDER}}` left anywhere in the HTML.
6. Run: `scripts/render.sh <folder> <basename>`
7. **Verify:** Read the generated PDF. Check it's one page (or the approved two),
   nothing truncated or overlapping. If overflow: tighten bullets (with user) and
   re-render.
8. Commit the output folder to git.

## Step 8 — Deliver

Send the PDF to the user with SendUserFile, and report the folder path with all
formats (PDF / docx / resume.txt for copy-paste). Mention any gap-report items
they said they'd think about.
