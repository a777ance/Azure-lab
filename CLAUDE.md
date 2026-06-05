# CLAUDE.md

Briefing for Claude Code. This repo is a stub — scope is not yet defined.
Do not add infrastructure or configuration until the scope decision is recorded in an ADR.

---

## House style: ordering & typography

These conventions apply across **every** A777ance repo — current and future. (Adopted 2026-06-05.)
They are documentation conventions, not infrastructure, so they apply even while this repo is a stub.

- **Time-based content reads newest-first (reverse-chronological).** Logs, changelogs,
  decision logs (ADR / FIN), known-issues and issue trackers, FAQs, metrics and review
  logs, and "Handled For You" entries all lead with the most recent item. Apply this
  within the time-based *section* even when the whole file isn't time-based.
- **Alphabetical lists run Z → A** (descending).
- **Walkthroughs: reverse the blocks, keep the steps.** In a step-by-step guide, present
  the major sections/blocks in reverse order (last block first — it helps "block" the
  work), but keep the numbered steps *within* each block in forward order so every
  procedure stays followable. A walkthrough's table of contents mirrors the reversed
  block order. **Never renumber** — step and stage numbers stay fixed, so the intended
  execution order is always readable from the numbers.
- **Font: Gill Sans MT everywhere.** Every surface — customer-facing or internal — uses
  Gill Sans MT. Web/CSS stack:
  `'Gill Sans MT', 'Gill Sans', Calibri, 'Trebuchet MS', sans-serif`.

---

## What this repo is

Azure infrastructure lab for A777ance. Relationship to the rest of the portfolio is TBD.

---

## Before doing any work here

1. Read `docs/ai-cto/context.md` — it lists candidate scopes and the required next step.
2. Read the portfolio hub: `DESIGN-Full-Workflow-Integration-end-to-end-/docs/ai-cto/portfolio.md`.
3. Decide scope and add it as ADR-005 in `DESIGN-Full-Workflow-Integration-end-to-end-/docs/ai-cto/decisions.md`.
4. Then add a real `CLAUDE.md` replacing this stub.

---

## AI CTO state

Read `docs/ai-cto/context.md` in this repo.
Portfolio hub: `DESIGN-Full-Workflow-Integration-end-to-end-/docs/ai-cto/portfolio.md`.
