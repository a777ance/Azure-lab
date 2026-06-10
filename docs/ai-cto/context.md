# AI CTO Context — azure-lab

Read alongside the portfolio hub: `../DESIGN-Full-Workflow-Integration-end-to-end-/docs/ai-cto/portfolio.md`.

**Last updated:** 2026-06-10 (fixed ADR numbering collision; noted stub CLAUDE.md exists)

---

## What this repo is

Azure infrastructure lab. Currently a stub — only LICENSE and README exist. Scope is undefined. Do not add infrastructure or configuration until the scope is chosen.

## Current state

- Status: empty stub (P3 tech debt, see `DESIGN/docs/ai-cto/tech-debt.md` TD-10)
- Stub `CLAUDE.md` only (house style + scope warning — replace once scope is decided)
- No infrastructure defined

## Candidate scopes (to decide before doing any work)

Pick one and document it as the **next free ADR number** (ADR-008 at the time of writing — check the
log first; ADR-005 is already taken by "Member dues") in `DESIGN/docs/ai-cto/decisions.md` before
touching this repo.

| Candidate | Relationship to existing stack |
| --------- | ------------------------------ |
| Azure VPN Gateway peering with on-prem WireGuard | Extends the wg0 tunnel to Azure; adds cloud egress |
| Azure DNS Private Resolver | Cloud-hosted split DNS to complement the t630 Unbound instance |
| Azure Arc for t630 management | Adds Azure policy/monitoring to the physical box |
| Azure Static Web Apps for Statements | Alternative to GitHub Pages with custom domain + CDN |

## Next step

Before any other work: define scope, add `CLAUDE.md`, open an issue or ADR recording the decision.
