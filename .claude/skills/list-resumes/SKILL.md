---
name: list-resumes
description: Show a table of all tailored resumes generated so far (date, company, role, files). Use when the user asks what resumes exist or wants to find a past one.
---

# List generated resumes

1. `ls output/` — each folder is one tailoring run named `YYYY-MM-DD_company_role[-vN]`.
2. For each folder, parse date/company/role from the name and check which files exist (pdf, docx, txt, gap-report.md).
3. Present a markdown table, newest first: Date | Company | Role | Formats | Folder. Link the folder paths.
4. If `output/` is empty, say so and point at `/tailor`.
