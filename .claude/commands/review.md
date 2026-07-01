---
description: QA review from fresh context — spawns a reviewer subagent that defaults to rejection
---

# /review

Spawn a QA reviewer subagent with fresh context to review recent work. The reviewer defaults to "NEEDS WORK" — it must be convinced the code is solid, not the other way around.

## When to Use

- After completing a course unit or a context-strategy module
- Before publishing the repo, pushing to GitHub, or finalizing README eval numbers (public, hard to undo)
- When you want a second opinion on an architectural or readability choice

## Two-model option (for public / hard-to-undo steps only)

For the GitHub publish and the README eval table, run the full adversarial ladder from the blog/`tinytandem` setup: Claude does the fresh-context QA pass below, then **Codex reviews the same diff adversarially** (different family, disjoint blind spots). A finding both flag is high-confidence; a finding only one flags is the other's blind spot. For routine unit work, the single Claude reviewer below is enough.

## Steps

1. **Determine review scope** — `git diff --stat` and `git diff --name-only` for changed/new files; read `PLAN.md` for the current unit's requirements and verification checklist
2. **Scale review depth** — under 200 lines: full detail. 200-1000: focus on the loop, tool dispatch, and context-assembly paths. Over 1000: architectural + spot-check
3. **Spawn reviewer subagent** (Agent tool, `model: "opus"`) with the template below
4. **Process the report** — PASS → proceed; NEEDS WORK → fix critical issues, then re-review. Don't argue with the reviewer; fix or explain to the user why you disagree

## Reviewer Prompt Template

Fill in `{{SCOPE}}`, `{{FILES}}`, `{{REQUIREMENTS}}`.

```
You are a QA Reviewer for TinyHarness, a minimal from-scratch coding-agent harness built as a teaching artifact and portfolio piece. Review recent work with fresh eyes. Default to "NEEDS WORK" — only pass if everything is genuinely solid.

## Context
{{SCOPE}}

## Files to Review
{{FILES}}

## Requirements & Design Decisions
{{REQUIREMENTS}}

## Your Task

1. Read all files listed above — every new and modified file.
2. Check for these issues:

### Correctness (CRITICAL)
- Does the implementation match the requirements / the unit's goal?
- The agent loop: is the model→tool→observation→loop cycle correct? Termination condition sound (no infinite loops, no premature stop)?
- Tool dispatch: are tool-call args validated? Are tool errors fed back to the model rather than crashing the loop?
- Context assembly: is each context strategy actually optional/toggleable? Does the bare loop still run with everything off?
- API usage: messages constructed correctly? Tool-use / tool-result blocks paired right? Token/usage accounting correct if it feeds the eval?
- Safety: are file-write / shell tools sandboxed to examples/ during demos? Any path that lets the loop escape the sandbox?

### Readability / Thesis (HIGH — this is the product)
- Can a developer understand the agent from loop.py alone? Is the loop linear and legible, or hidden behind indirection?
- Are abstractions earning their complexity? Anything that should be inlined for clarity?

### Reproducibility (HIGH for anything in the README)
- Can someone run this from a clean clone + `make setup` + `make demo`?
- Are eval numbers reproducible (seed/temperature pinned)? Do the claimed numbers match what the code would produce?
- Are required env vars documented?

### Code Quality (MEDIUM)
- Dead code, unused imports, duplicated logic
- Functions > 50 lines, files > 400 (loop.py exempt if cohesive), nesting > 4
- Missing type hints on public functions; inconsistent naming

3. Run `make lint` and `make test`; verify they pass.
4. Return a structured report:

## Status: PASS | NEEDS WORK

## Critical Issues (must fix before shipping)
- [file:line] Description. Why it matters. How to fix.

## Warnings (should fix, not blocking)
- [file:line] Description. Why it matters.

## Observations (nice to fix)
- [file:line] Description.

## What Works Well
- Positive observations.

Be thorough. Be harsh. The implementer wants a clean, defensible public repo, not reassurance.
```

## Rules

- Always use `model: "opus"` for the reviewer
- Never skip the review before publishing the repo or pushing public eval numbers
- The reviewer's report is advisory — the user makes the final call
- After fixing critical issues, consider re-running `/review`
