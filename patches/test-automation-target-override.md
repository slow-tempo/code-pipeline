# test-automation: target-override patch

**Upstream:** [nothern131/agent-skills](https://github.com/nothern131/agent-skills),
`skills/test-automation/` (Apache-2.0)

## The problem

The skill's step 1 *requires* framework auto-detection (pytest.ini / pyproject.toml /
setup.cfg, or a `tests/` directory for unittest). On a codebase with perfectly good
tests that don't follow that layout — e.g. bare-assert scripts run as
`python test_core.py` — detection reports "no framework found" and the skill stops,
even though the tests run fine directly.

Measured: `pytest --collect-only` → "no tests collected"; direct run →
`ALL TESTS PASSED` in 0.05s. The skill was fine; the layout check was the blocker.

## The patch

Added **step 0 — target override** (takes precedence over framework detection):

> If the user or agent names specific files/directories, **skip framework detection**
> and run them directly:
> - Bare-assert scripts (`python xxx.py` style): run `python3 <file>`.
>   Exit code 0 with no failure trace in output = pass; non-zero = fail, full output
>   becomes the failure detail.
> - pytest/unittest style: `python3 -m pytest <file> -v --tb=short`.
>
> Only fall through to step 1 (framework detection) when no target is given.

Parsing and the Closed Loop (fix → re-run, max 3 rounds, then stop and report)
are unchanged.

## Applying it

The section above (in Chinese, matching the upstream file) is inserted before
`### 1. 检测测试框架` in `skills/test-automation/SKILL.md`, with an attribution
note. Apache-2.0 permits modification with a change notice, which the note provides.
