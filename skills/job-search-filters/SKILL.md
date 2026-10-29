---
name: job-search-filters
description: Create, review, or reorder the user's job-search queries — LinkedIn boolean filters and alerts, Google site: searches on Ashby/Greenhouse/Lever, and job-board settings — stored in the search filters file named in config.md (default "job platforms.md"). Use when the user asks for job filters, search strings, alerts, or which roles/companies to search for.
---

# Job search filters

**Data folder:** `${user_config.data_dir}`; paths below are relative to it. If that path is empty or still shows the placeholder, ask the user where their data folder is and tell them to set it with `/config`.

Read `config.md` there first (**Search preferences**: filters file, its language, locations, alert settings, exclusions). Keep new content in the filters file's existing language and structure; if the file doesn't exist yet, create it as a numbered list of filters.

## Fit order
Take it from `cv-database/Target Roles.md`, where archetypes are ordered by fit. List filters in that order and label each one with its fit (strongest, strong, second tier…).

## Rules for writing LinkedIn boolean queries
- **Syntax:** `AND` / `OR` / `NOT` in UPPERCASE, straight quotes, parentheses for grouping. Exclude the seniority terms from `config.md` (e.g., `NOT (intern OR internship OR junior)`).
- **Anchor on the user's stack:** e.g., `AND (Databricks OR Spark …)`, using the ★★★ skills from `Skills Inventory.md`. Titles alone pull in noise from other stacks.
- **Watch broad titles** like "machine learning engineer": they bring in jobs centered on the user's weakest areas. Only use them anchored to the context they fit (platform, MLOps…).
- **Exclude stacks the user has ruled out.** Read the ✗ rows in `Skills Inventory.md` and the "Skipped" rows in the Applications log (`CV Database.md`). When a ✗ skill is the *core* of the postings it appears in (in the title, e.g., "Scala / Spark"), add it to the `NOT (...)` list. Don't exclude ✗ skills that are usually just one requirement among many (e.g., dbt in a Spark role); those postings can still be a good fit.
- **Prefer a few precise filters.** Propose the minimum and explain the trade-off (fewer results but a better fit) instead of piling on variants.
- **One alert per filter** with the alert settings and locations from `config.md`.
- **Mirror changes in the Google site: queries:**
  `site:jobs.ashbyhq.com OR site:boards.greenhouse.io OR site:jobs.lever.co (...) (<locations>) remote`
- **Salary search:** to find postings that publish pay, add `"USD"` or a salary filter. See the `recruiter-outreach` skill for pay ranges.

## When reviewing an existing filter
Explain overlap vs. complementarity, noise sources, and fit risk. Propose a tighter version, but don't overwrite the user's filter without asking.
