---
name: tailor-cv
description: Build a CV/resume tailored to a specific job posting or company from the user's CV skills database, as an ATS-safe PDF + DOCX in their CV output folder. Use whenever the user shares a job description or link (Lever, Greenhouse, Ashby, LinkedIn…), names a company/role they want to apply to, or asks to update/rebuild an existing tailored CV.
---

# Tailor a CV from the skills database

## Locations
- **Data folder:** `${user_config.data_dir}`. It holds the user's personal data; paths below are relative to it. If that path is empty or still shows the placeholder, ask the user where their data folder is and tell them to set it with `/config`.
- **Settings:** read `config.md` in the data folder first (output folder, file naming, standing facts, environment). If it doesn't exist, offer to copy the sample `${CLAUDE_PLUGIN_ROOT}/examples/data/` into the data folder and fill it in together.
- **Database (source of truth):** `cv-database/`. Read `CV Database.md` (hub + applications log), `Skills Inventory.md`, `Target Roles.md`, `Profile.md` (contact details), and the `Experience - <Company>.md` bullet banks.
- **CV output:** `<CV output folder>\<CV folder pattern>\` from `config.md` (default `cvs/` in the data folder; a relative path resolves against the data folder), containing `<CV file name>.pdf`, `.docx`, and the `content.json` used to build it.
- **Build tooling (in the plugin):** `${CLAUDE_PLUGIN_ROOT}/skills/tailor-cv/scripts/build_cv.ps1`, `assets/base_template.docx` next to it (styles and header layout, placeholder text only), and `assets/content.example.json` (fictional, shows every field).

## Workflow

1. **Get the real job description.** If you have a link, WebFetch it and save a copy in `job_descriptions/`. If you only have a company name, search its postings and ask which one before writing. A generic role at the same company can be very different from the one the user means.
2. **Map the gaps.** Make a quick table that lists each must-have and nice-to-have, with its evidence in the Skills Inventory: ★★★, ★★, ★, ✗ (not done), or unknown. Include the poster's screening questions (e.g., "Requirements added by the job poster: 5+ years of X"); they often reject applicants automatically.
3. **Confirm the unknowns before writing.** Use AskUserQuestion with `multiSelect`. Each option must explain in plain words what the item means, because people pick jargon items by mistake. Ask them to select only what they have done hands-on. Never claim ✗ items. If they select something new, read it back in your final message so they can correct it.
   - **Ask about scope, not just yes/no.** "Built it", "operate or support it", "migrated it" and "familiar, someone else wrote it" lead to different bullets. Familiar-only goes in the skills line as "familiar with X", never in a bullet as hands-on work.
   - **A question about a term means the claim isn't confirmed.** If the user later asks what a selected term means (e.g., "semantic layer", "schema-on-read", "dimensional modeling"), explain it, re-check the claim against what they actually did, and fix the CV.
   - **The user's newest answer wins**, even over a database note marked ✗ or "not done". Correct the database (with `cv-database-update`) instead of arguing from the old note.
4. **Fit check: recommend skipping when the core doesn't match.** Before writing, decide whether the posting is worth a CV. Recommend skipping it when the role's main stack (title, core requirements, day-to-day duties) is mostly ✗, or when the user would fail the screening questions truthfully; matching only nice-to-haves isn't enough. Say it plainly, with the reasons. If the user agrees: log it as "Skipped" with the reason in the Applications log, add its gaps to `Upskilling Projects.md`, and recommend the project that would close them. Mention cheaper alternatives (a short recruiter message) only as an option. Also follow any fit preferences in `config.md`.
5. **Write `content.json`** in a scratch directory. Start from the starting point named in `config.md` (usually the newest `content.json` in the CV output folder), or from `${CLAUDE_PLUGIN_ROOT}/skills/tailor-cv/assets/content.example.json`. Rules:
   - **Header:** `name` and `contact` (`line`, `linkedin`, `linkedinUrl`) come from `Profile.md`. The build fails without them.
   - **Headline:** mirror the job title from the posting, then add 3–4 of the posting's key terms. It must fit on one line; check the preview.
   - **Job titles:** follow the standing facts in `config.md` (e.g., official title plus scope in parentheses).
   - **Facts and metrics:** use only what the database contains, and never invent numbers. For items newly confirmed without a metric, write a bullet with no number. Use each metric in only one bullet; if two bullets describe the same work, put the metric where it reads strongest for this posting.
   - **Role verbs match the user's real scope:** "built", "supported", "served as the escalation point", "contributed to". Don't upgrade "supported" to "built" or "managed".
   - **Keywords:** spell the posting's terms exactly as it does (e.g., "Databricks Jobs", "MLflow", "Unity Catalog"), and make each important term appear in the summary, skills, and at least one bullet.
   - **Length:** up to about 9 bullets for the current role and 4 for the previous one; compress older roles to 1–3. Aim for 2 pages.
   - **Language:** English unless the posting is in another language. Keep the `languages` line for remote or international roles.
   - **`banned`:** list every ✗ skill plus the previous CV's footer or role strings. The check matches whole words, ignoring case, so short terms like "ORC" don't flag "orchestration".
   - **`footer` and `docTitle`:** set both to the target role.
6. **Build** (PowerShell):
   ```powershell
   & "${CLAUDE_PLUGIN_ROOT}/skills/tailor-cv/scripts/build_cv.ps1" -Content <content.json> -OutDir "<output folder>\<folder>" -BaseName "<CV file name>" -WorkDir <scratch>\cvwork
   ```
   Pass `-OutDir` as an absolute path (data folder + CV output folder + CV folder), since the shell's working directory may be elsewhere. Then copy `content.json` into the output folder so the CV can be rebuilt later.
7. **Verify.** Don't skip any of these:
   - Read the `page-N.png` previews. Check for layout breaks and a lonely last page.
   - Read `raw.txt`, the text in the order an ATS sees it. Bullets must stay with their text, and company and dates must sit on one line.
   - The script must print `banned: none found`. Pages should be 2 or fewer.
8. **Record in the database:**
   - Add newly confirmed facts using the `cv-database-update` skill.
   - Add a row to the `CV Version History.md` table, with no blank line before it so the table doesn't break.
   - Add a row to the Applications log in `CV Database.md`.
   - Add the posting's unmet requirements to the gap tracker in `Upskilling Projects.md`.
9. **Report back:**
   - the file paths
   - what you targeted
   - what you left out on purpose, and the project in `Upskilling Projects.md` that would close each gap
   - any metrics that would strengthen the bullets
   - interview prep for claims at the edge of the user's experience (e.g., how to describe a star schema they built, or what to say about a tool they only know)

## Format decision
- **Submit the PDF.** It is text-based, exported by Word, with fonts embedded, and Lever/Greenhouse/Ashby read it well. Keep the .docx as the editable source and as a fallback for forms that ask for Word.
- **ATS-safe rules** (all handled by the script): one column, no tables, Unicode bullets (not Symbol-font glyphs), real headings, clean metadata, and a footer updated to the new role.

## Environment
- **Requirements:** Windows with Microsoft Word (COM) for the PDF export. Poppler (`winget install --id oschwartz10612.Poppler -e`) enables the ATS text and preview checks; the script finds it under the WinGet packages folder even when it's not on PATH. Check `config.md` for what else is or isn't installed before planning around a tool.
- **Stuck Word processes:** if a Word automation process holds a file open, stop only `WINWORD.EXE` processes whose command line contains `/Automation`. Never stop the user's own Word windows.
- **Template changes:** the script cuts the template at the SUMMARY heading (paragraph id `5CC89F3A`) and fills the four header runs (name, headline, contact line, LinkedIn handle). For a new visual design, pass a different template with `-Template <path.docx>` (keep it in the data folder, since the plugin folder is replaced on updates). It must keep the SUMMARY heading paragraph, or the anchor in the script must change.
