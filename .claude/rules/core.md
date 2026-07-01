# Core Rules

## Code Quality

- Many small files (200-400 lines, 800 max). Functions under 50 lines. Max 4 levels of nesting
- **The core loop is the exception that proves the rule:** keep `loop.py` cohesive and linear even if slightly long — readability of the loop beats file-size dogma. Don't split it into clever indirection
- Schema-based input validation at system boundaries (CLI args, tool inputs, MCP responses, model tool-call args). Trust internal code
- After refactoring, identify dead code explicitly. Ask before deleting

## Implementation Behavior

- Surface assumptions as a numbered list before non-trivial tasks. "Correct me now or I'll proceed with these"
- When confused, STOP and ask. Name the confusion, present the tradeoff, wait
- Summarize changes after modifications: what changed, what was left alone, any concerns
- Use corrective framing: "you should be doing X — are you still doing it?" beats "remember to do X"

## Safety

- Never hardcode credentials. Reference from `.env` (`ANTHROPIC_API_KEY`, etc.)
- The agent loop runs shell + file-write tools. During demos, sandbox tool execution to `examples/` — never point the loop at the real repo tree
- Before destructive operations (deleting files, `git` history rewrites, force-push), confirm with the user
- Publishing the repo, `git push`, and the public project page require explicit approval — a public GitHub repo is visible immediately

## Harness-Specific

- **Bare-loop-first** — the harness must run with every context strategy OFF. Build and verify the bare loop before adding skills/MCP/sub-agents. Each strategy is additive and toggleable
- **One strategy per unit** — don't pre-build a module before its course unit. The repo's commit history should read like the course
- **Measure, don't assert** — when a context strategy is supposed to help, show it: token count and task-pass with the strategy on vs off. The eval is the evidence
- **Determinism where it matters** — fix a seed / temperature for runs that go in the README's eval table so the numbers reproduce

## Context Hygiene

- After compaction, re-read `PLAN.md` and relevant files before continuing
- Write important outputs (configs, eval numbers, decisions) to files immediately
- When switching between unrelated units, suggest `/clear`
- Keep fewer than 10 MCP servers enabled
