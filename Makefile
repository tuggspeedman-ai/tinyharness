.PHONY: setup fmt lint test test-all smoke demo eval clone-course help

# Verify the actual course repo URL in Unit 0 (the HF Context Course may ship code in a dedicated repo).
COURSE_REPO ?= https://github.com/huggingface/context-course.git

help:
	@echo "Common targets:"
	@echo "  setup         uv sync (base deps)"
	@echo "  fmt           ruff format"
	@echo "  lint          ruff check"
	@echo "  test          fast unit tests (skips slow/integration)"
	@echo "  test-all      all tests incl. slow + integration (hits the API)"
	@echo "  smoke         one Claude API round-trip — verifies key + env"
	@echo "  demo          run the agent on the toy repo in examples/ (Unit 6+)"
	@echo "  eval          token + pass-rate table across context strategies (Unit 6+)"
	@echo "  clone-course  refresh course-content/ from the HF context-course repo"

setup:
	uv sync

fmt:
	uv run ruff format .

lint:
	uv run ruff check .

test:
	uv run pytest -v -m "not slow and not integration"

test-all:
	uv run pytest -v

smoke:
	uv run python -c "import os; from dotenv import load_dotenv; load_dotenv(); \
	import anthropic; c=anthropic.Anthropic(); \
	m=c.messages.create(model=os.getenv('TINYHARNESS_MODEL','claude-sonnet-4-6'), max_tokens=16, \
	messages=[{'role':'user','content':'reply with the single word: ok'}]); \
	print('API ok ->', m.content[0].text.strip())"

demo:
	uv run python -m tinyharness.cli run --demo

eval:
	uv run python -m tinyharness.eval

# Refreshes the read-only local copy of the course under course-content/ (gitignored).
# Pulls the unit pages + capstone project scaffolds, dropping heavy non-reading artifacts.
clone-course:
	@tmp=$$(mktemp -d); \
	echo "Cloning $(COURSE_REPO) ..."; \
	git clone --depth 1 $(COURSE_REPO) $$tmp/context-course || { echo "Clone failed — set COURSE_REPO=..."; rm -rf $$tmp; exit 1; }; \
	mkdir -p course-content/units course-content/projects; \
	cp -R $$tmp/context-course/units/en/. course-content/units/; \
	cp -R $$tmp/context-course/projects/. course-content/projects/; \
	cp $$tmp/context-course/README.md course-content/COURSE-README.md; \
	find course-content/projects -name 'dag.seed.json' -delete; \
	find course-content/projects -name 'uv.lock' -delete; \
	rm -rf $$tmp; \
	echo "Refreshed course-content/ ($$(find course-content/units -name '*.mdx' | wc -l | tr -d ' ') unit pages)"
