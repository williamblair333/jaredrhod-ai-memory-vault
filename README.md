# AI Memory Vault

> **Never used Claude Code?** Start at [jaredrhod.com](https://jaredrhod.com): pick your situation and it routes you to the right path.

Give your AI a real, persistent memory. This is the open-source system that turns an Obsidian vault into your AI's working memory, so it remembers everything across sessions, lives outside the model with no size ceiling, and pulls back exactly what it needs in one step. Free to use, share, and build on, just not to resell (see LICENSE).

## The build

Before you run the build: **put your vault under git** (`git init` in the vault folder, then commit). The build gives an AI write access to your notes and tells it to consolidate and edit without asking every time — that's what makes the system self-maintaining, and it's only safe because every change is reversible. The build script walks you through it and won't start without checking.

- **[ai-memory-vault.md](ai-memory-vault.md):** the build script. Run it inside Claude and it interviews you, then builds a complete, self-maintaining system: a boot config, a folder structure around your real projects, daily notes that write themselves, a profile that updates as the AI learns about you, and "Jobs" that teach it to do your recurring tasks your way. Your vault becomes the AI's memory, so it lives outside the model with no size ceiling, and the AI holds only what the current task needs while reaching anything else in one step. Watch the walkthrough: [https://www.youtube.com/playlist?list=PLN7lTYpeRLOc](https://www.youtube.com/playlist?list=PLN7lTYpeRLOc)

## AI Priming

AI Priming is having your AI read a specific set of your notes before it gives you the answer or output you want. For example, before my agent writes a marketing email, it reads my copywriting notes, my email marketing notes, my customer avatar, and my company knowledge base. Then it writes. This is extremely powerful because, with AI, context is king. When you "prime" your AI with the knowledge and skills it needs prior to its output, your results will always be better and more accurate.

Every job gets its own set of notes. An email needs different notes than a Facebook ad. The vault keeps all of your notes organized in one place and tells your AI which notes to read for which job. You set that up once, and your AI primes itself on every task after that.

Full definition and examples: https://jaredrhod.com/ai-priming

## Templates

Starter files for the system. Every spot that needs your information is marked `[FILL IN: ...]` — drop a template in and tell your AI "fill this in for me," and it will interview you and write it in your voice (each template carries that instruction for the AI). Or fill them out by hand if you prefer.

- **[CLAUDE.md](templates/CLAUDE.md):** the boot config. Goes in the folder you run Claude Code from (your **working directory**), kept **out of your vault** so the vault stays pure notes and doesn't get tangled once you have more than one project. Claude Code auto-loads it every session and points the AI to your vault. Holds your agent's identity — its name, role, and personality — plus your startup sequence and the rules that can't lapse.
- **[VAULT-INDEX.md](templates/VAULT-INDEX.md):** the operating manual. This one lives **inside your vault** (it's a note, not config). Your profile, your projects, the full vault rules, and how you like to work with the AI.
- **[PERSONAL-CONTEXT.md](templates/PERSONAL-CONTEXT.md):** the on-demand half of your profile — the people in your life, your health, your values. Goes **inside your vault** at `[N] - Personal/Personal Context.md`, and is deliberately **not** read at boot. Everything in VAULT-INDEX.md is uploaded to your AI provider as context on every turn and kept in their logs; that's a reasonable trade for a project list, not for medical details or other people's names. The AI opens this one only when a task actually needs it.
- **[DAILY-NOTE.md](templates/DAILY-NOTE.md):** the daily-note template. Goes **inside your vault** at `01 - Daily Notes/Daily Note Template.md`. Every daily note gets created from it, so the log keeps one consistent, scannable shape.
- **[MEMORY.md](templates/MEMORY.md):** the pointer for Claude Code's own memory. Goes in **Claude Code's project folder** (`~/.claude/projects/...`, not your vault). It redirects the native memory back into the vault so you never end up with two memory layers that drift apart.

## Maintaining this repo

Each template exists **twice**: once in `templates/`, and once embedded verbatim inside `ai-memory-vault.md` so that file works standalone. Edit one, edit the other in the same commit.

That is not just a style rule. The build agent follows the embedded copy, so when the two disagreed, every vault built from this repo inherited the wrong daily-note frontmatter — one bad note per day, silently, for as long as it went unnoticed.

`scripts/check-template-sync.sh` enforces it, and CI runs it on every change to the build doc, the templates, or the check itself:

```
bash scripts/check-template-sync.sh
```

It checks that every pair resolves, that frontmatter values agree across all pairs, and that the daily-note pair is byte-identical. It deliberately does **not** byte-diff `VAULT-INDEX.md` or `CLAUDE.md` against their embedded copies — those differ by design, because `templates/` is written for a human filling it in while the embedded copy is written for an agent filling it from the interview.

If it fails because a section moved, update the `PAIRS` list at the top of the script. It fails closed on a heading it cannot find, rather than passing green while checking nothing.

## Support

Free to use, and always will be. If this helped you out, you can buy me a coffee:

[![Support me on Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/jaredrhod)

## License

Copyright (c) 2026 Jared Rhodenizer.

The contents of this repository are licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License (CC BY-NC-SA 4.0). You are free to share and adapt them, with attribution, for noncommercial purposes, as long as you license your contributions under these same terms. Full terms are in the LICENSE file and at https://creativecommons.org/licenses/by-nc-sa/4.0/
