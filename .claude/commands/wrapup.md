---
description: Session close — update project state and capture decisions
---

# /wrapup

End every productive session by persisting what happened.

## Steps

1. **Update `PLAN.md` "Current State" section:**
   - What was accomplished this session
   - What's blocked or needs attention
   - What to do next session
   - Check off completed unit/milestone tasks
   - **If a unit was completed:** collapse its detail to a short summary in `PLAN.md` (keep Decisions Log entries — they're cumulative). Move full detail to `PLAN-archive.md` if it exists

2. **Append to the in-repo `.claude/memory/MEMORY.md`** (only if there's something worth remembering):
   - IMPORTANT: this is `<project-root>/.claude/memory/MEMORY.md`, the canonical project memory — NOT the global auto-memory system
   - Non-obvious decisions and why (e.g., "argparse over typer — one fewer dep, the CLI is 3 flags")
   - Gotchas discovered (e.g., "MCP stdio transport needs the server process kept alive for the whole loop")
   - Conventions established (e.g., "every eval run pins temperature=0 + seed in the run name")
   - Don't add obvious things. Don't duplicate what's in `PLAN.md`

3. **Check MEMORY.md size** — if approaching 200 lines, suggest a consolidation pass

4. **Brief summary** — 3-5 sentences of what happened and what's next

## Rules

- Don't skip step 2 even if the session was short — small decisions compound
- Write decisions with enough context for future-you to understand *why*
- This should take under 2 minutes. If it's taking longer, you're over-documenting
