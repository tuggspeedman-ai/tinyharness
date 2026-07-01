# TinyHarness

> A minimal, readable, from-scratch coding-agent harness — with **context engineering made visible**.

TinyHarness is the bare agent loop (model → tools → observation → repeat) plus the things that actually make an agent good: **skills, MCP tools, sub-agents, and lifecycle hooks** — each as a *swappable, measurable* module you can toggle on and off. The point isn't to compete with Claude Code or Codex. It's to make the one claim those harnesses are built on legible:

> **Agent quality depends on the caliber of the context the model has when it acts.**

So TinyHarness lets you run the *same task* with different context strategies and shows you the difference — in tokens and in task success.

> 🚧 **Work in progress.** Built unit-by-unit while working through the [Hugging Face Context Course](https://huggingface.co/learn/context-course/unit0/introduction). See the roadmap below.

## Why

Most agent harnesses hide the loop behind an SDK. TinyHarness keeps it in ~a few hundred readable lines you can understand top to bottom — and then layers context engineering on top, one technique at a time, so you can *see* what each one buys you.

## Quickstart

```bash
git clone https://github.com/tuggspeedman-ai/tinyharness
cd tinyharness
cp .env.example .env        # add your ANTHROPIC_API_KEY
make setup
make smoke                  # one Claude API round-trip
make demo                   # run the agent on the toy repo in examples/
```

## The demo (target)

```bash
# same task, different context strategies — watch the cost and success change
make eval
```

| Strategy            | Tokens | Task pass |
|---------------------|-------:|:---------:|
| bare loop           |    …   |    …      |
| + skills            |    …   |    …      |
| + MCP tools         |    …   |    …      |
| + sub-agents        |    …   |    …      |
| + lifecycle hooks   |    …   |    …      |

_(Numbers populated as the course progresses.)_

## Roadmap (one module per course unit)

- [ ] **Unit 0** — bare Claude API round-trip + repo scaffold
- [ ] **Unit 1** — agent skills
- [ ] **Unit 2** — MCP tool connection
- [ ] **Unit 3** — plugins & workflows
- [ ] **Unit 4** — multi-agent / sub-agent delegation
- [ ] **Unit 5** — lifecycle hooks & observability
- [ ] **Unit 6** — the minimal loop, wired together (capstone) + the eval demo

## License

MIT — see [LICENSE](LICENSE).

---

Built by [Jonathan Avni](https://jonathanavni.com). Part of an ongoing exploration of agent harnesses and context engineering.
