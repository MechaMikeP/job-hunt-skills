# Job hunt config

Settings for the job-hunt-skills plugin. Every skill reads this file first. This sample belongs to a fictional user (Alex Rivera); replace each value with your own.
Contact details (name, email, phone, LinkedIn) live in `cv-database/Profile.md`, not here.

## Paths
Relative paths are relative to this data folder.
- **CV database:** `cv-database/`
- **CV output folder:** `cvs/` (generated CVs; an absolute path elsewhere also works)
- **CV folder pattern:** `YYYY.MM.DD <Role> - <Company>`
- **CV file name:** `Alex_Rivera_<Role>_Resume` (.pdf + .docx)
- **Job descriptions archive:** `job_descriptions/`
- **Search filters file:** `job platforms.md`

## Search preferences
- **Filters file language:** English
- **Locations for alerts:** Mexico; second alert for "Latin America"
- **Alert settings:** Remote, Mid-Senior, Full-time, past 24 hours, daily
- **Seniority exclusions:** intern, internship, junior

## Outreach and salary
- **Reply language/tone:** the recruiter's language; friendly and professional
- **Current employer (conflict check):** Acme Retail, which recruiters may describe as "a multinational retail company in Guadalajara"
- **Salary anchor:** $95k USD per year, total compensation
- **Reference points (researched 2026-01-10; re-verify):**
  - Remote for US companies from Mexico: ~$80k–120k USD/yr
  - Local senior salaries: ~$45k–75k USD/yr
  - The anchor as a USD contractor ≈ $75–85k on local payroll, depending on tax setup
- **Companies most likely to pay the anchor (best odds first):**
  1. US remote-first product companies hiring in Mexico
  2. US talent marketplaces
  3. Funded LATAM fintech and tech

## Application preferences
- **Fit check first:** recommend skipping a posting when its core stack or seniority doesn't match, log it as "Skipped", and suggest the project in `cv-database/Upskilling Projects.md` that closes the gap.
- **Pay check:** flag postings likely to pay well below the salary anchor (total compensation); the user decides.

## Standing facts (confirmed; don't re-ask)
- **Acme Retail title:** official title is **Senior Data Engineer**.
- **Runtime cut:** the pipeline runtime reduction is **35%** (an older CV said 40%).
- **Never claim:** dbt, Snowflake (both ✗ in `Skills Inventory.md`).
- **GitHub:** link only the personal account on CVs.
- **Starting point for a new CV:** the newest `content.json` in the CV output folder, or the plugin's example if there is none.

## Environment
- Microsoft Word: installed (required for the PDF export)
- Poppler: installed via winget (enables the ATS text and preview checks)
- Not installed: Python, LibreOffice
