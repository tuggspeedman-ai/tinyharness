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
	@echo "  clone-course  clone the HF context-course repo into course-materials/"

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

clone-course:
	@mkdir -p course-materials
	@if [ -d course-materials/context-course ]; then \
		echo "course-materials/context-course already exists — skipping"; \
	else \
		git clone $(COURSE_REPO) course-materials/context-course || \
		echo "Clone failed — verify the course repo URL (set COURSE_REPO=...)"; \
	fi
