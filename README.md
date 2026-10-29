# Job Hunt Skills

A [Claude Code](https://code.claude.com) plugin that runs a job search from a personal **CV skills database**. You keep your facts in Markdown notes (they work well as an Obsidian vault), and Claude turns them into a tailored, ATS-safe CV for each posting.

| Skill | What it does |
|---|---|
| `tailor-cv` | Reads a job posting, maps it against your skills, asks about the gaps, and builds a tailored CV (PDF + DOCX). Then it checks the CV the way an ATS reads it. |
| `cv-database-update` | Adds or corrects facts, metrics, skills and certifications, and keeps every note consistent. |
| `job-search-filters` | Writes LinkedIn boolean filters, alerts, and Google `site:` searches for Ashby, Greenhouse and Lever. |
| `recruiter-outreach` | Reviews or drafts replies to recruiters, and advises on salary and contractor vs payroll offers. |

## How it works

```
job posting ──► tailor-cv ──► content.json ──► build_cv.ps1 ──► CV .docx ──► Word ──► CV .pdf
                    ▲                                                                │
     your data folder (cv-database/)                    Poppler: page previews + ATS text check
```

- **Your data stays yours.** The plugin holds only the workflow. Your database, settings, generated CVs and saved postings live in a **data folder** you choose (OneDrive, an Obsidian vault, anywhere), and the plugin asks for its path when you enable it.
- **The database is the source of truth.** Every skill has an evidence level (★★★ proven with a metric, ★★ used, ★ familiar, ✗ never claim). CVs use only what the database supports, so metrics are never invented.
- **ATS-safe output.** The CV has one column, no tables, Unicode bullets, real headings and clean metadata. Before you see a CV, the build extracts its text, checks that it reads in order, and flags any banned terms.

## Install

1. **Requirements:** Windows, Microsoft Word (used to export the PDF), and Claude Code. Optional: Poppler, which enables the preview and ATS checks:
   ```powershell
   winget install --id oschwartz10612.Poppler -e
   ```
2. **Create your data folder** by copying the sample from this repo, [`examples/data/`](examples/data/), to wherever you keep personal files:
   ```
   your-data-folder/
   ├── config.md            settings: CV output folder, salary anchor, standing facts
   ├── cv-database/         your skills database (Profile, Skills Inventory, Experience - <Company>, …)
   ├── cvs/                 generated CVs, one folder per application (created on first use)
   ├── job_descriptions/    saved postings (created on first use)
   └── job platforms.md     your search filters (created on first use)
   ```
3. **Add the marketplace and install the plugin** (in Claude Code):
   ```
   /plugin marketplace add MechaMikeP/job-hunt-skills
   /plugin install job-hunt-skills@job-hunt-skills
   ```
   When it asks for your data folder, enter its full path **without quotes**, even if it contains spaces. You can change it later in `/config`.
4. **Start a new Claude Code session** so the skills load.
5. **Fill in your data.** Replace the sample (a fictional Alex Rivera) with your own history. Claude can help: paste your current CV and ask it to populate the database.

## Usage

You don't need to call the skills by name. Talk normally, and Claude picks the right one from what you paste. The plugin is installed for your user, so it works in a session opened from any folder.

| You want to… | Say or paste | Skill |
|---|---|---|
| Apply to a job | A job link, or "make me a CV for the Data Engineer role at Acme" | `tailor-cv` |
| Add or fix a fact | "I also built X at work, it cut Y by 25%", or "I've never used Terraform" | `cv-database-update` |
| Search for jobs | "Give me a LinkedIn filter for remote Databricks roles", or "review my filters" | `job-search-filters` |
| Answer a recruiter | Their message plus your draft reply, or "what salary should I ask for?" | `recruiter-outreach` |

To run a skill directly, type `/job-hunt-skills:` and pick one, e.g. `/job-hunt-skills:tailor-cv https://jobs.lever.co/...`.

### What a CV run looks like
1. Claude reads the posting and saves a copy in `job_descriptions/`.
2. It shows a table comparing the posting's requirements with the evidence in your database.
3. It asks about anything your database doesn't cover. Only tick what you've actually done; anything you confirm is added to the database.
4. It builds the PDF and DOCX in `cvs/YYYY.MM.DD <Role> - <Company>/`, then checks the page previews and the ATS text.
5. It logs the application and reports what it targeted, what it left out on purpose, and which metrics would strengthen your bullets.

Submit the PDF; the DOCX is the editable source.

## Customizing the CV design

`build_cv.ps1` fills the header of the Word template (name, headline, contact line, LinkedIn) and regenerates everything from the SUMMARY heading onward, using the template's styles. To use your own design, edit a copy of [`skills/tailor-cv/assets/base_template.docx`](skills/tailor-cv/assets/base_template.docx) in Word. Keep the SUMMARY heading paragraph, store the copy in your data folder, and pass it with `-Template`.
