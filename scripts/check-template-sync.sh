#!/usr/bin/env bash
#
# check-template-sync.sh — guard the templates/ files against the copies of them
# embedded in ai-memory-vault.md.
#
# WHY THIS EXISTS
# ---------------
# The build doc embeds each template verbatim so it works standalone, which means
# every template exists twice. They drifted, and a parenthetical after section 4.3
# asserted the drift was intentional: it claimed the daily-note template file is
# `type: reference` while notes made from it are `type: log`. Because section 4.3 is
# what the build agent actually follows, every vault built from this repo got a
# template stamped project: meta / type: reference, and every daily note copied from
# it inherited that. A prose "keep these in step" note already sat above section 4.2
# and did not prevent it. Hence a mechanical check.
#
# WHAT IT DOES AND DELIBERATELY DOES NOT DO
# -----------------------------------------
# It does NOT require every embedded block to match its template byte for byte.
# VAULT-INDEX.md and CLAUDE.md differ from their embedded copies by design — 78 and
# 67 lines at the time of writing — because templates/ is written for a human filling
# it in ("[FILL IN: ... e.g. \"The Coffee Shop\"]") while the embedded copy is written
# for an agent filling it from discovery answers ("[Project 1 Name]"), and
# templates/CLAUDE.md carries a setup section the agent does not need. A byte-diff
# would fire on all of that, be correct about nothing, and get deleted.
#
# It checks the invariant that actually broke:
#   · every pair resolves          — fail closed if a heading moved or a file vanished
#   · frontmatter values agree     — all pairs
#   · byte-identical               — DAILY-NOTE pair only, which is genuinely one file
#
# Run from the repo root:  bash scripts/check-template-sync.sh
set -uo pipefail

# Overridable so the check can be exercised against fixtures without copying the repo.
# Defaults are the real files; CI sets neither.
DOC="${DOC:-ai-memory-vault.md}"
TPL_DIR="${TPL_DIR:-templates}"

# heading|template basename|mode      mode: fm | identical  (identical implies fm)
PAIRS=(
  "### 4.2 VAULT-INDEX.md|VAULT-INDEX.md|fm"
  "### 4.3 Daily Note Template|DAILY-NOTE.md|identical"
  "### 4.5 CLAUDE.md|CLAUDE.md|fm"
)

fail=0
note() { printf '  %s\n' "$1"; }
bad()  { printf 'FAIL  %s\n' "$1"; fail=1; }

# Extract the first fenced block after a heading.
# Fence-aware by backtick count so a nested ``` inside a ```` block does not close it.
# No interval quantifiers — mawk on ubuntu-latest and gawk disagree about --re-interval.
extract_block() {
  awk -v want="$1" '
    state == 0 { if (index($0, want) == 1) state = 1; next }
    state == 1 {
      if (substr($0, 1, 3) != "```") next
      n = 0; while (substr($0, n + 1, 1) == "`") n++
      state = 2; next
    }
    state == 2 {
      line = $0
      sub(/[ \t]+$/, "", line)
      if (length(line) == n) {
        allticks = 1
        for (i = 1; i <= n; i++) if (substr(line, i, 1) != "`") allticks = 0
        if (allticks) exit
      }
      print
    }
  ' "$DOC"
}

# Emit the YAML frontmatter body, or nothing if the file has none.
frontmatter() {
  awk 'NR == 1 && $0 == "---" { inside = 1; next }
       inside && $0 == "---" { exit }
       inside { print }'
}

echo "template-sync: checking ${#PAIRS[@]} pairs against $DOC"

[ -f "$DOC" ] || { bad "$DOC not found — run from the repo root"; exit 1; }

for pair in "${PAIRS[@]}"; do
  heading="${pair%%|*}"
  rest="${pair#*|}"
  tpl="${rest%%|*}"
  mode="${rest##*|}"
  tpl_path="$TPL_DIR/$tpl"

  echo
  echo "$tpl  [$mode]"

  # --- fail closed: the template file must exist -------------------------------
  if [ ! -f "$tpl_path" ]; then
    bad "$tpl_path is missing. Either restore it or drop its entry from PAIRS."
    continue
  fi

  # --- fail closed: the embedded block must resolve and be non-empty -----------
  block="$(extract_block "$heading")"
  if [ -z "$block" ]; then
    bad "could not extract a block for heading '$heading' in $DOC."
    note "The heading was renamed, renumbered, or its fenced block is empty."
    note "This check keys on heading text, so it fails closed rather than passing"
    note "green while guarding nothing. Update PAIRS in this script to match."
    continue
  fi

  # --- frontmatter values must agree (all pairs) -------------------------------
  emb_fm="$(printf '%s\n' "$block" | frontmatter)"
  tpl_fm="$(frontmatter < "$tpl_path")"

  if [ "$emb_fm" != "$tpl_fm" ]; then
    bad "frontmatter disagrees between $DOC '$heading' and $tpl_path."
    note "embedded: $(printf '%s' "$emb_fm" | tr '\n' ' ')"
    note "template: $(printf '%s' "$tpl_fm" | tr '\n' ' ')"
    note "These must match. The frontmatter belongs to the note the template"
    note "produces, not to the template file — every copy inherits it."
    continue
  fi
  note "frontmatter agrees: $(printf '%s' "$tpl_fm" | tr '\n' ' ')${tpl_fm:+}"
  [ -n "$tpl_fm" ] || note "frontmatter: none in either (expected for this file)"

  # --- byte-identity (DAILY-NOTE pair only) ------------------------------------
  if [ "$mode" = "identical" ]; then
    if ! printf '%s\n' "$block" | diff -u - "$tpl_path" > /tmp/tsync.$$ 2>&1; then
      bad "$tpl_path and the block under '$heading' are not byte-identical."
      note "These two are one file kept in two places; edit one, edit the other."
      sed 's/^/    /' /tmp/tsync.$$
      rm -f /tmp/tsync.$$
      continue
    fi
    rm -f /tmp/tsync.$$
    note "byte-identical to the embedded block"
  fi
done

echo
if [ "$fail" -ne 0 ]; then
  echo "template-sync: FAILED"
  exit 1
fi
echo "template-sync: OK — ${#PAIRS[@]} pairs consistent"
