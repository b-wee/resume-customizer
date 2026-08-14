---
name: tailor
description: Generate a resume tailored to a specific job posting (URL or pasted text). Selects and rewrites bullets from the master profile, flags gaps, and renders PDF/docx/txt after user review.
---

# Tailor a resume to a job posting

Turn the master profile + a job posting into a targeted one-page resume, with a
review step before rendering.

## Step 1 — Capture the posting

- **URL given:** fetch with WebFetch. If it fails or returns a login wall (LinkedIn often does), ask the user to paste the posting text instead.
- **Text given:** use it directly.
- Extract company name and role title (confirm with user if ambiguous).

## Step 2 — Analyze the posting

Extract and keep for later steps:
- Hard requirements (must-haves) and nice-to-haves
- Keywords and vocabulary the posting uses (exact phrasings matter for ATS)
- What the role actually emphasizes (leadership? scale? shipping speed? domain?)

## Step 3 — Read the whole profile

Read every file in `profile/` including all of `profile/jobs/`. If `profile/jobs/`
is empty or files are placeholder-only, STOP and tell the user to run
`/import-resume` or `/add-job` first — do not generate a thin resume.

## Step 4 — Draft the tailored resume

- **Bullets:** For each job, select the profile facts most relevant to this
  posting and compress them into succinct, strong bullets (action verb, what,
  measurable impact). Mirror the posting's vocabulary **only where truthful**
  (profile says "Kafka", posting says "event streaming" → "event streaming
  (Kafka)" is fine; claiming Kubernetes because the posting wants it is not).
- **Confidential financials:** never put absolute revenue, budget, or cost
  figures from private companies on a resume. Convey scale with percentages,
  growth multiples (15x), relative framings (8-figure), headcount, users, or
  volume instead. Publicly reported figures are allowed.
- **Writing style:** no em-dashes and no semicolons anywhere in
  resume text. Use commas, periods, or parentheses instead. Avoid other
  AI-writing tells. Plain professional sentences only.
- **STRICT TRUTHFULNESS:** every claim must trace to something in the profile.
  No invented skills, numbers, or experiences. When unsure, leave it out and
  put it in the gap report.
- **Order:** most relevant bullets first within each job; 3-5 bullets for recent/
  relevant roles, 1-3 for older/less relevant ones. Reverse-chronological jobs.
- **HARD CAP: maximum 6 bullets per job.** If more than 6 bullets of genuinely
  relevant content exist, merge related ones and FLAG the overflow to the user
  during the review step (say what was merged or dropped and why), so they can
  veto the cuts.
- **Summary:** 2-3 lines targeted at this role, distilled from `summary.md` + jobs.
- **Skills section:** only profile-listed skills, subset + ordering chosen for
  this posting.

## Step 5 — Gap report

List posting requirements (must-have and nice-to-have) that the profile does not
cover, each with: what the posting wants, and a question like "Do you have any
X experience I should add to your profile?" If the user supplies new experience,
append it to the relevant job file (dated heading, as in /update-job) and
incorporate it — the profile grows, the resume stays truthful.

## Step 6 — Review in chat

Present, in this order: proposed output name, the drafted resume content
(markdown), and the gap report. Iterate until the user approves. Also confirm
length: if content clearly can't fit one page, propose what to cut, or ask if
two pages is acceptable.

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
5. Run: `scripts/render.sh <folder> <basename>`
6. **Verify:** Read the generated PDF. Check it's one page (or the approved two),
   nothing truncated or overlapping. If overflow: tighten bullets (with user) and
   re-render.
7. Commit the output folder to git.

## Step 8 — Deliver

Send the PDF to the user with SendUserFile, and report the folder path with all
formats (PDF / docx / resume.txt for copy-paste). Mention any gap-report items
they said they'd think about.
