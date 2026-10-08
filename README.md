# code-pipeline

A measured, no-nonsense coding pipeline for AI agents.

Most skill collections tell you **what** to install. This one tells you **in what order, and why** — with measurements, not marketing.

## The pipeline

```
ponytail → write → codeguard → test-automation → code-review → product-engineer
```

1. **ponytail** (before writing): 7-rung ladder to the smallest change that fully works. Anti-over-engineering.
2. **Write**: thin slices, each left in a working, verifiable state.
3. **codeguard** (after writing): rule-based scan — error handling, security, diagnostics, resource management.
4. **test-automation** (run): execute the tests. On failure: fix → re-run, max 3 rounds, then stop and report.
5. **code-review-and-quality** (before done): 5-axis judgment review (correctness, readability, architecture, security, performance).
6. **product-engineer** (throughout): restate the outcome, report only what was observed, never print a number you didn't count.

It's a *pipeline*, not a pile: each stage catches what the previous one can't.

## Why this order — measured, not asserted

Shot out on a ~1,300-line Python codebase (a Monte Carlo game-balance simulator):

| Finding | Detail |
|---|---|
| codeguard vs code-review overlap | **12%** — they complement, they don't duplicate |
| codeguard blind spot | **No performance dimension** — the review caught a K² Python loop the scanner can't see |
| test-automation blind spot | Framework detection **fails on bare-assert scripts** → fixed with a target-override patch (see `patches/`) |
| ponytail on already-lean code | ~1% line reduction — its value here is preventive, not corrective |
| codeguard scoring | The 0–100 formula's `max_possible` is undefined — treat the score as indicative, count by severity |

Full method and numbers: [`docs/shootout.md`](docs/shootout.md)

## Install

**As an agent skill** (any agent that reads `SKILL.md`):

```bash
npx skills add <this-repo>
```

or copy `skills/code-pipeline/` into your skills directory
(`~/.agents/skills/`, `.claude/skills/`, or your Antigravity/Gemini plugin skills dir).

**Quick install script:**

```bash
./install.sh            # → ~/.agents/skills/code-pipeline
./install.sh /target/dir # → custom directory
```

Say **"pipeline"** (or just ask for code) and the agent runs all six stages automatically.
Say **"no pipeline"** to opt out for a given task.

## What's in this repo

- `skills/code-pipeline/SKILL.md` — the pipeline skill (original, MIT)
- `patches/test-automation-target-override.md` — the patch that lets test-automation run a named file instead of requiring a pytest layout
- `docs/shootout.md` — how the pipeline order was measured

## Dependencies

The pipeline *orchestrates* these skills (install them separately):

- [ponytail](https://github.com/DietrichGebert/ponytail) (MIT) — anti-over-engineering
- [nothern131/agent-skills](https://github.com/nothern131/agent-skills) (Apache-2.0) — `codeguard`, `test-automation`
- [product-engineer](https://github.com/Bubblegunn/product-engineer) (MIT) — engineering habits
- [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) (MIT) — `code-review-and-quality`, `incremental-implementation`

## License

MIT — see [LICENSE](LICENSE).
