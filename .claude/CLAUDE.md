# Developing job-hunt-skills

This repo is a public Claude Code plugin (`.claude-plugin/plugin.json`, skills in `skills/`).

- **Privacy:** never commit personal data. Users' data lives in their own data folder (the `data_dir` plugin option), never in this repo. `examples/data/` uses only the fictional Alex Rivera.
- **Paths in skills:** refer to user data as `${user_config.data_dir}` and to plugin files as `${CLAUDE_PLUGIN_ROOT}`; Claude Code substitutes both when it loads a skill.
- **Testing:** run `claude plugin validate .` after changing a manifest. To use local changes, add this folder as a marketplace (`/plugin marketplace add <path>`) and run `/plugin marketplace update job-hunt-skills`.
- **CV builder:** after changing `build_cv.ps1` or the template, build `skills/tailor-cv/assets/content.example.json` and check the page previews and `raw.txt`.
