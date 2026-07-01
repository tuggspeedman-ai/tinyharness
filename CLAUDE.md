# CLAUDE.md — TinyHarness

## Project

**TinyHarness** — a minimal, readable, from-scratch coding-agent harness, built while working through the [Hugging Face Context Course](https://huggingface.co/learn/context-course/unit0/introduction). The thesis: **context engineering made visible** — the bare agent loop plus skills / MCP / sub-agents / lifecycle hooks as *swappable, measurable* modules.

The explicit goal is to finish the course with a **public, open-source, demo-able harness** on [github.com/tuggspeedman-ai](https://github.com/tuggspeedman-ai), portfolio-worthy and linkable from [jonathanavni.com/projects](https://jonathanavni.com/projects).

**Read `PROJECT-SPEC.md` for the full brief** (goals, architecture, course→deliverable mapping, definition of done). Read `PLAN.md` for current state.

## Core Principles

- **Readability is the product.** The core loop must be understandable end to end. Resist abstraction that hides the loop — if a reviewer can't understand the agent from `loop.py` alone, we've failed the thesis
- **Simplicity first** — prefer the boring obvious solution. Can this be fewer lines? Is this abstraction earning its complexity?
- **No over-engineering** — this is a teaching harness, not a production agent. Don't add features, providers, or error handling beyond what the demo needs. Don't touch code you weren't asked to touch
- **Verification is the #1 lever** — every unit ends with a runnable demo of that unit's module (a generation sample, a toggled-strategy run, an eval number). Give every task a way to prove it worked
- **Naive-then-optimize** — get the bare loop working on a toy task first. Verify. Then add a context strategy. Never skip the bare version
- **Push back when warranted** — if an approach has clear problems, say so, propose an alternative, accept override. Sycophancy is a failure mode
- **Learning-first** — this is educational. When a concept is new (MCP transport, skill injection, sub-agent context boundaries), explain the "why" before implementing
- **Compaction-safe artifacts** — write configs, decisions, and eval numbers to files immediately. Don't rely on conversation history

## Workflow

- **Unit-driven milestones** — each Context Course unit is a milestone in `PLAN.md`. Don't fork off the curriculum until we've hit the core learning for that unit. Add each context strategy *only when its unit is reached*
- **Course repo is reference, not code** — read the course's example harnesses (Claude Code / Codex / OpenCode) for understanding; write our own implementation in this repo
- **Lightweight two-model setup** — Claude orchestrates (owns plan + memory). Pull in Codex as an adversary *only* before something public/hard-to-undo (the GitHub publish, README eval numbers). Most unit work is low-stakes — implement directly
- **Delegate when it helps** — research (reading course material, SDK docs) and fresh-context QA reviews benefit from isolation. Use a subagent with `model: "opus"` and a precise brief
- Enter plan mode for any non-trivial task (3+ steps or an architectural decision)
- Use `/start` at session start, `/wrapup` at session end, `/review` before any public/expensive action

## Session Management

- `/clear` between unrelated units; `/compact` to keep focus while clearing noise
- **Two-correction rule**: if wrong twice on the same thing, `/clear` and write a sharper prompt
- Feed raw data (tracebacks, API responses, token counts) instead of your interpretation
- Use neutral prompts — "trace the data flow through the loop and report findings" not "find the bug"

## Tech Stack

| Component | Choice |
|-----------|--------|
| Language | Python 3.12+ *(see PROJECT-SPEC decision #1 — overridable at kickoff)* |
| LLM provider | Claude (Anthropic API) via the official `anthropic` SDK |
| Default loop model | `claude-sonnet-4-6` (configurable; escalate to `claude-opus-4-8` for hard tasks) |
| MCP | official MCP Python SDK (Unit 2) |
| CLI | `typer` or stdlib `argparse` — keep it thin |
| Testing | pytest (lightweight — this is a learning project) |
| Linting | ruff |
| Package manager | uv |

## Safety

- Never hardcode credentials. `ANTHROPIC_API_KEY` and any other secrets live in `.env`
- The harness executes shell commands and writes files **as a tool** — sandbox the demo to the `examples/` toy repo. Never let the agent loop run destructive commands against the real working tree during a demo
- External communications (`git push`, publishing the repo, the project page) require explicit approval — a public GitHub repo is visible immediately and hard to fully undo

## Project State Files

- **`PROJECT-SPEC.md`** — the brief. Goals, architecture, course→deliverable mapping, definition of done. **Committed** (it's part of the public story). Read at kickoff
- **`PLAN.md`** — single source of truth for active work. Current unit in full detail; completed units collapsed. Decisions Log is cumulative. Read at session start, update at session end. **Gitignored** (internal)
- **`ORIENT.md`** — human onboarding doc. **Gitignored**
- **`.claude/memory/MEMORY.md`** — accumulated decisions & gotchas as topic files. Append after non-obvious choices. **Gitignored**

## Key Documents

| Document | When to Read |
|----------|-------------|
| `PROJECT-SPEC.md` | Kickoff, and whenever scope feels fuzzy |
| `PLAN.md` | Every session start — current state, active unit, decisions |
| `ORIENT.md` | First-time setup, common commands |
| `.claude/memory/MEMORY.md` | When making a decision touching an area with prior gotchas |
| `course-content/units/unitN/` | When working a unit — read the source pages before building the module |

## Course Content (local reference)

The full HF Context Course is checked out locally at **`course-content/`** (gitignored — read-only reference, not our code). **Read the relevant unit here instead of fetching the web page.**

- `course-content/units/unitN/*.mdx` — the course pages for each unit (intro, concepts, hands-on, quizzes). `course-content/units/_toctree.yml` has the canonical page ordering
- `course-content/projects/` — the course's capstone project scaffolds (real skills under `.agents/skills/`, sub-agents under `.claude/agents/`, hook/settings examples) — concrete references for Units 1/4/5
- `course-content/SOURCE.md` — provenance (upstream repo + commit) and how to refresh (`make clone-course`)

When working a unit, read its `course-content/units/unitN/` pages first, *then* port the concept into TinyHarness. The course teaches through Claude Code / Codex / OpenCode; our job is to rebuild each idea in our own loop.

## Course Links

- **Course home:** https://huggingface.co/learn/context-course/unit0/introduction
- **Upstream repo:** https://github.com/huggingface/context-course
- Units: 0 setup · 1 skills · 2 MCP · 3 plugins/workflows · 4 multi-agent · 5 lifecycle/hooks · 6 minimal loop (bonus/capstone)
