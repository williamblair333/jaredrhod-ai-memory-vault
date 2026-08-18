---
status: active
project: personal
type: reference
---
# Personal Context

The private half of my profile: the people around me, my health, and my values.

**This note is not loaded at boot, and that is the point.** VAULT-INDEX.md gets read into the model's context at the start of every conversation, with every AI I use — so everything in that file is transmitted to a model provider on essentially every turn and kept in their logs. This note is read on demand instead, so the sensitive material only leaves my machine when a task genuinely calls for it.

(Starter template. Every spot that needs your information is marked **[FILL IN: ...]**. Fill them in by hand, or tell your AI "interview me and fill in my Personal Context" — but see the note to the AI just below. Any section you don't want to keep, delete outright; the system works fine without all three.)

(**AI:** read this note only when the current task actually needs it — work involving the people I deal with, my health, or my values. Say so when you open it. Don't quote from it back into VAULT-INDEX.md, a daily note, or any other file that gets read at boot, and don't summarize it into a handoff doc. If [FILL IN: ...] markers remain, offer to interview me and fill them in — one topic at a time, everything optional, and never press. If I hesitate or skip something, move on and delete that section. Then delete this block.)

## Key People

[FILL IN: one line per important person in your work and life — partners, team, family, mentors. Keep it to what the AI actually needs to do your work well; these people didn't opt into being described here, so write what you'd be comfortable with them reading.]

- **[[Name]]** — [FILL IN: who they are and their role to you]

## Health

[FILL IN: only what you want the AI to factor into its work — routines, constraints, goals. Or delete this section. Anything you'd not want sitting in a provider's logs, leave out; there is no obligation to fill this in, and the system loses nothing without it.]

## Beliefs

[FILL IN: the values that shape how you decide things, in bullets, first person — only if you want the AI weighing tradeoffs against them. Or delete this section.]

---

## Rules for this note

- **On-demand only.** Nothing here gets copied into VAULT-INDEX.md, CLAUDE.md, a daily note, or any other boot-loaded file. If it belongs in the vault's permanent boot layer, it doesn't belong here.
- **Updates need a reason to be open.** The AI may fold in what it learns about these three topics, but only while this note is already open for a task — never open it just to write to it.
- **Health and Beliefs get confirmed, not inferred.** Before writing anything to those two sections, say what you're about to record and wait for a yes. An inferred medical or ideological "fact" becomes permanent record that every future session treats as true.
- **Log the fact of an update, not its content.** In the daily note's Profile Updates, write "**Personal Context:** updated" — not what changed.
