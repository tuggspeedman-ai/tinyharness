# TinyHarness — Project Spec & Handoff

> **Read this first.** This is the brief for the project. It explains *what we're building, why, and how the course feeds the deliverable.* Hand it to a fresh Claude Code session at kickoff. Pair it with `CLAUDE.md` (how to work) and `PLAN.md` (current state).

## One-liner

**TinyHarness** is a minimal, readable, from-scratch coding-agent harness — the bare agent loop (model → tools → observation → repeat) with **context engineering made visible**: skills, MCP, sub-agents, and lifecycle hooks each as a *swappable, measurable* module you can toggle on and off.

The project is built *while* working through the [Hugging Face Context Course](https://huggingface.co/learn/context-course/unit0/introduction). Each course unit contributes one module; by the end of the course the harness is complete.

## Why this project exists

Two goals, in priority order:

1. **Learn context engineering by building it.** The course teaches context engineering for code agents (skills, MCP, plugins, multi-agent, lifecycle). The fastest way to internalize it is to build the harness those concepts describe, from scratch, instead of only configuring an existing one (Claude Code / Codex / OpenCode).
2. **Ship a portfolio piece.** The final deliverable is a public, open-source, demo-able repo on GitHub ([github.com/tuggspeedman-ai](https://github.com/tuggspeedman-ai)), linkable from [jonathanavni.com/projects](https://jonathanavni.com/projects).

These two goals are not in tension — they're the same `unit-driven` arc. We don't write disconnected unit notebooks; we keep compounding on one harness.

### How it fits the existing portfolio

The portfolio has a model trained from scratch (TinyChat), a fine-tuning pipeline, a multi-agent research app (Deep Research Agent), and an always-on SDK agent (KuchiClaw) — but **no harness / context-engineering artifact**, despite that being a core interest. TinyHarness fills that gap.

- **Brand fit:** continues the `Tiny*` line and the "build it from scratch to actually understand it" thread from TinyChat — pointed at the *harness* layer instead of the *model* layer. Narrative: "I trained the model from scratch; here's the agent loop from scratch."
- **Differentiates from KuchiClaw:** KuchiClaw *consumes* the Claude Agent SDK. TinyHarness *is* the thing the SDK hides — pedagogical, not a product. No overlap.

## The thesis (what makes it more than a toy)

A bare agent loop is ~150 lines and has been written many times. The differentiator is **making context engineering measurable**: the same task, run with different context strategies, with the token cost and success delta shown side by side. That turns the course's central claim — *"agent quality depends on the caliber of available context"* — into something you can demonstrate, not just assert.

The demo "money shot": a CLI that runs a toy coding task on a small repo, with flags to toggle context strategies (`--skills`, `--mcp`, `--subagents`, `--compaction`), plus a tiny eval that reports tokens-used and task-pass for each configuration. **Context engineering, visualized.**

## Architecture (target shape — refine during the course)

```
tinyharness/
  src/tinyharness/
    loop.py          # Unit 6 — the minimal agent loop (model → tools → observe → repeat)
    tools.py         # core tools: read_file, write_file, run_bash, list_dir
    context/         # the pluggable-context thesis lives here
      skills.py      # Unit 1 — load & inject agent skills
      mcp.py         # Unit 2 — connect tools via Model Context Protocol
      plugins.py     # Unit 3 — plugins / reusable workflows
      subagents.py   # Unit 4 — multi-agent delegation (bounded sub-context)
      lifecycle.py   # Unit 5 — hooks, observability, lifecycle automation
    config.py        # model id, provider, strategy toggles
    cli.py           # `tinyharness run <task>` with --strategy flags
  examples/          # toy repo + sample tasks the demo runs against
  eval/              # measures tokens + task-pass across strategy configs
  tests/
```

**Design rules (carry from the start):**
- The core loop must stay *readable end to end* — that's the whole point. Resist abstraction that hides the loop. Target: a developer reads `loop.py` once and understands the agent.
- Every context strategy is *optional and toggleable*. The harness must run with all of them off (bare loop) and degrade gracefully.
- Each strategy is added *only when its course unit is reached* — don't pre-build modules ahead of the curriculum.

## Course → deliverable mapping (milestones)

The [Context Course](https://huggingface.co/learn/context-course/unit0/introduction) is 6 units. Each is a milestone in `PLAN.md`:

| Unit | Course topic | TinyHarness contribution |
|------|--------------|--------------------------|
| **0** | Setup & prerequisites | Repo scaffold, env, smoke test against the Claude API |
| **1** | Building & sharing agent skills | `context/skills.py` — load/inject skills into the loop |
| **2** | Connecting tools via MCP | `context/mcp.py` — attach an MCP server's tools |
| **3** | Plugins & workflows | `context/plugins.py` — reusable workflow primitives |
| **4** | Multi-agent coordination | `context/subagents.py` — bounded sub-agent delegation |
| **5** | Observing & automating lifecycles | `context/lifecycle.py` — hooks + observability |
| **6** | Minimal agent loop | `loop.py` — the core; the capstone. Wire it all together + the eval/demo |

> Course units may reorder slightly once we see the real material — treat this table as the plan-of-record, update it in `PLAN.md` as units land. The course covers Claude Code, Codex, and OpenCode as *reference* harnesses; we read them, but write our own implementation.

## Definition of done (the portfolio bar)

- [ ] Public repo on `github.com/tuggspeedman-ai`, MIT-licensed, clean commit history
- [ ] `README.md` that explains the thesis and shows the demo in <60 seconds of reading
- [ ] One-command demo: clone → `make setup` → `make demo` runs the agent on the toy repo
- [ ] The eval table (tokens + pass-rate across strategy configs) reproducible via `make eval`
- [ ] Core loop is genuinely readable — a reviewer can understand the agent from `loop.py` alone
- [ ] Short writeup / project page linkable from jonathanavni.com/projects (and optionally a blog post)

## Key decisions (revisit at kickoff)

1. **Language: Python + `uv`** *(default — matches the HF ecosystem and the hf-smol-course workflow we're reusing)*. The course's reference harnesses are TS/Node; we read those but implement in Python for readability and HF-ecosystem fit. **Overridable** — if you'd rather match the harness ecosystem, TypeScript is a defensible swap. Decide in Unit 0.
2. **LLM provider: Claude (Anthropic API)** via the official SDK. Default loop model configurable in `config.py` (start with `claude-sonnet-4-6` for cost/latency on the loop; escalate to `claude-opus-4-8` for hard tasks). `ANTHROPIC_API_KEY` in `.env`.
3. **Scope discipline / non-goals:** not a production agent, not a Claude Code competitor, not multi-provider. It's a *teaching harness* that makes context engineering legible. Say no to features that don't serve the demo or the readability thesis.

## Working method (lightweight version of the two-model setup)

This project reuses the orchestrator workflow from the personal meta-harness setup (see the "Two Models Today, Meta-Harnesses Tomorrow" blog post and the `tinytandem` skeleton), but **stripped down** — it's a small, low-risk project:

- **Claude is the orchestrator.** Owns `PLAN.md`, the decisions log, and memory. `/start` to load state, `/wrapup` to persist it, `/review` for a fresh-context QA pass.
- **Codex (optional adversary).** Only pull in the full adversarial ladder before something public-facing or hard-to-undo (the GitHub publish, the eval numbers that go in the README). Most unit work is low-stakes — implement directly.
- **Unit-driven, verification-first.** Every unit ends with a runnable demo of that unit's module. Small-first: get the bare loop working before adding any context strategy.
