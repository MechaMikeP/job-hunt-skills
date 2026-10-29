---
name: recruiter-outreach
description: Review or draft the user's messages to recruiters and hiring managers (LinkedIn, email, WhatsApp) and advise on salary expectations, contractor vs payroll offers, and which companies pay a target range for remote work. Use when the user pastes a recruiter message or reply draft, asks what salary to ask for, or compares offers.
---

# Recruiter outreach and salary positioning

**Data folder:** `${user_config.data_dir}`; paths below are relative to it. If that path is empty or still shows the placeholder, ask the user where their data folder is and tell them to set it with `/config`.

Read `config.md` there first (**Outreach and salary**: tone, current employer, salary anchor, reference points, company tiers) and `cv-database/Profile.md` for contact details.

## Reviewing or drafting a message
Reply in the recruiter's language, with the tone set in `config.md`. Give a short critique (what to change and why), then a ready-to-paste version.

**Checklist**
1. **Nothing that undercuts the user.** Remove hedges like "it's hard for me to calculate" or "I'm not sure". Recruiters anchor on any uncertainty.
2. **Salary:** state one clear figure as **gross annual USD** (or the currency in `config.md`). Then ask about the payment scheme: *contractor in USD or local payroll?* That keeps the number while leaving room to adjust it on the same basis.
3. **One-line pitch:** give the strongest proof for this role from the database (the ★★★ bullets in `Experience - <Company>.md` that match the role). Mention the tailored CV is attached.
4. **Contact details:** phone from `Profile.md` (say WhatsApp if they use it), plus availability for a call.
5. **Conflict check:** if the role is described like the current employer in `config.md`, point that out, and suggest checking the contract for non-solicitation or conflict clauses.

## Salary guidance
- **Search before quoting numbers.** Pay bands change. Run a WebSearch and cite sources. Never present company pay bands as verified unless a source states them. Treat the reference points in `config.md` as a starting point and note their research date; update them when you find newer data.
- **Contractor vs payroll:** a contractor pays their own taxes and social security and gets no statutory bonuses or benefits, so a contractor rate is worth noticeably less than the same payroll figure (see `config.md` for the user's estimate). Always compare offers on the same basis, and offer to calculate the net.
- **Companies most likely to pay the anchor:** use the tiered list in `config.md`, best odds first.
- **If they come in low:** keep the anchor, and ask about flexibility on base or extras (USD payment, certifications, bonus) before lowering it.
