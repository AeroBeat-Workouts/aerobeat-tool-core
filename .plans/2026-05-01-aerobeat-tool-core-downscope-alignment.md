# AeroBeat Tool Core Downscope Alignment

**Date:** 2026-05-01  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Align `aerobeat-tool-core` with the downscoped AeroBeat v1 truth so shared tool-side contracts and repo-facing scope language do not reintroduce removed product assumptions.

---

## Overview

After aligning docs, authoring, content, feature, input, and asset core surfaces, `aerobeat-tool-core` is the next shared contract lane to inspect. This repo should reflect the narrower AeroBeat v1 truth without implying broader removed gameplay/package/input scope. Because tool-core often becomes a quiet dependency and type-definition hub, stale assumptions here can spread indirectly even when product-facing repos are clean.

This slice starts with a repo-local audit to determine whether the repo needs only wording cleanup, or whether deeper shared DTOs/contracts/examples/tests still encode pre-downscope assumptions.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Active plan for this repo-local cleanup slice | `.plans/2026-05-01-aerobeat-tool-core-downscope-alignment.md` |
| `REF-02` | Updated AeroBeat docs source of truth | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs` |
| `REF-03` | Parent coordination plan and matrix | `/home/derrick/.openclaw/workspace/projects/openclaw-chip/.plans/2026-05-01-aerobeat-polyrepo-downscope-audit.md` |
| `REF-04` | Recently aligned tool/content/input surfaces | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-tool-content-authoring` |

---

## Tasks

### Task 1: Audit `aerobeat-tool-core` for stale downscope assumptions

**Bead ID:** `oc-drz`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Audit this repo against the updated docs and aligned shared contract surfaces. Identify stale tool-core assumptions such as removed gameplay/package/input scope encoded in shared tool-side contracts, README/docs/examples/tests, or overly broad repo-purpose wording. Do not edit yet; produce an execution-ready list.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/`
- `src/`
- `tests/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-01-aerobeat-tool-core-downscope-alignment.md`
- `docs/**`
- `src/**`
- `tests/**`

**Status:** ✅ Complete

**Results:** Completed the stale tool-scope audit. Main finding: the repo is very small and has no tracked code/test/DTO surfaces currently reasserting removed gameplay/package/input assumptions. The only meaningful stale-scope surface is `README.md`, which still frames `aerobeat-tool-core` too broadly as a generic universal tooling/backend hub. The useful follow-up is a narrow README truth-alignment pass that clarifies tool-core owns tool-common DTOs/workflow/result/progress/settings-style contracts, not canonical content schemas, shared structural content validation rules, gameplay semantics, or blanket universal assembly dependency.

---

### Task 2: Apply the repo cleanup and scope alignment

**Bead ID:** `oc-7uo`  
**SubAgent:** `primary`  
**Role:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** After the audit/action list is approved, update this repo so its shared tool-core contracts, docs, examples, and tests match the downscoped AeroBeat v1 truth. Commit and push by default.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/`
- `src/`
- `tests/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-01-aerobeat-tool-core-downscope-alignment.md`
- `docs/**`
- `src/**`
- `tests/**`

**Status:** ✅ Complete

**Results:** Applied the narrow README truth-alignment pass. `README.md` now tightens the opening summary around tool-common contracts, reframes the architecture role around shared Tool-lane DTOs/interfaces, fixes dependency wording so `aerobeat-tool-core` is an intentional shared dependency for concrete `aerobeat-tool-*` repos rather than a universal dependency hub, adds explicit non-ownership boundaries so content schemas/shared structural validation/gameplay-runtime semantics/presentation stay out of this repo, and names likely v1 contract categories such as import/export/migration DTOs, workflow results, progress/diagnostic reports, settings/persistence, and orchestration interfaces. Validation used `git diff -- README.md`, `git diff --check`, and `git status --short`. Changes were committed/pushed as `e41997f` (`docs: align tool-core scope to downscoped v1`). The repo also has untracked `.plans/` state, which was intentionally left out of the coder commit.

---

### Task 3: QA and audit the alignment

**Bead ID:** `oc-u1t` (QA), `oc-2hr` (Auditor)  
**SubAgent:** `primary`  
**Role:** `qa` then `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Independently verify that this repo no longer reasserts removed gameplay/package/input assumptions through shared tool-core surfaces and stays aligned with the updated AeroBeat truth.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/`
- `src/`
- `tests/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-01-aerobeat-tool-core-downscope-alignment.md`
- `docs/**`
- `src/**`
- `tests/**`

**Status:** ⏳ Pending

**Results:** QA and auditor beads created and staged behind the coder pass.

---

## Final Results

**Status:** ⚠️ Partial

**What We Built:** Draft repo-local plan for the next shared tool-scope cleanup slice.

**Reference Check:** Pending repo audit and execution.

**Commits:**
- None yet.

**Lessons Learned:** Shared contract repos can quietly reintroduce stale worldview assumptions even when user-facing repos look clean, so they need the same audit discipline.

---

*Completed on 2026-05-01*