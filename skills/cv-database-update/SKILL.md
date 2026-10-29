---
name: cv-database-update
description: Add or correct facts in the user's CV skills database (cv-database/) — new achievements, metrics, skills, certifications, courses, projects, title or date corrections, or a skill they confirm or deny having. Use whenever the user mentions something they did at work that isn't in the database, corrects a claim ("I haven't used X", "it's 40%"), or after a tailored CV introduced newly confirmed facts.
---

# Update the CV skills database

The database is the single source of truth. CVs are generated from it, so a wrong fact here spreads to every future CV.

**Data folder:** `${user_config.data_dir}`; paths below are relative to it. If that path is empty or still shows the placeholder, ask the user where their data folder is and tell them to set it with `/config`. Read `config.md` there first: its **Standing facts** are confirmed and must not be re-asked.

## Files and what goes where
| File | Holds |
|---|---|
| `Skills Inventory.md` | One row per skill: **Level · Evidence · Last used**. |
| `Experience - <Company>.md` | Bullet bank grouped by theme with `#tags`, best wording first, `[source CV]` markers, interview-depth notes, and open questions. |
| `Profile.md` | Contact, education, certifications (with IDs), awards, languages, GitHub. |
| `Target Roles.md` | Role types, ordered by fit: lead skills, which bullets to use, gaps. |
| `CV Version History.md` | Version table, inconsistencies (✅ when resolved), build pipeline. |
| `CV Database.md` | Hub, tailoring workflow, tag list, applications log. |
| `Upskilling Projects.md` | Gap tracker (gaps from real postings) and the projects that close them, plus the personal GitHub plan. |

All files are in `cv-database/`. See `${CLAUDE_PLUGIN_ROOT}/examples/data/cv-database/` for the expected format, and copy missing files from there.

## Evidence levels (Skills Inventory)
- ★★★ used at work with a quantified result · ★★ used at work, no metric (or used in the past) · ★ coursework, listed with no story (⚠️), or familiar only (works next to it, but someone else built it)
- **✗ not done.** Keep it as a row with the date it was corrected, so it is never claimed again. Mention it as a learning gap if a posting asks for it.

## Rules
1. **Never invent metrics.** If a fact has no number, write the bullet without one and add a ⚠️ line asking for it. Give a fill-in template: `"Did [what] across [N scope] using [tool], reducing/improving [metric] by [X]."`
2. **Corrections win.** Update every place the fact appears: Inventory, bullet bank, Version History, Target Roles, the standing facts in `config.md`, and any CV `content.json`. Mark the old claim as corrected with the date; don't silently delete the history.
3. **Decide how detailed it should be.** Put a one- or two-line CV wording in the bullet bank. Put deeper technical detail under "Interview depth (keep off the CV)".
4. **Several skills behind one result** (e.g., a cost cut that came from both infrastructure and code tuning): write one bullet per angle, and note that they belong together.
5. **Tables:** no blank line inside a Markdown table, or the rows after it fall out. Keep the `updated:` frontmatter current.
6. **Language:** keep each note in the language it already uses (`config.md` says which language the filters file uses).
7. **Check before adding** whether the skill already has a row, and update it rather than duplicating it.
8. **New standing fact?** When the user settles something that should never be asked again (official title, a ✗ skill, a corrected metric), add it to **Standing facts** in `config.md`.
9. **Record the scope, not just the skill.** Note whether the user built it, operates or supports it, migrated it, or only knows it (someone else wrote it). Bullets must use matching verbs.
10. **Record what a term meant to the user** when it differed from the industry meaning (e.g., "semantic layer" understood as agent-readable documentation). Mark the industry term ✗ and add a row for what they actually did, so the mix-up isn't repeated.
11. **Same work, two stories?** When the user confirms that two bullets describe the same work, note it in both places and say which bullet carries the metric, so a CV never repeats it.
12. **Gaps go to `Upskilling Projects.md`.** When a posting asks for a ✗ skill, add it to the gap tracker there with the posting and date, and link it to a project.
