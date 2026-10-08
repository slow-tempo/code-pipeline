# Shootout: how the pipeline order was measured

**Target:** a ~1,300-line Python codebase — a Monte Carlo simulator for balancing a
dice deckbuilding roguelike (6 core modules: dice roller, Yahtzee evaluator, game
loop, 3 player agents, 12-card pool, 15 boss gimmicks). Offline, no database, no
network. Think "typical solo-dev research code": already lean, no test framework
(bare-assert scripts run as `python test_core.py`).

**Method:** each skill was applied to the same code, findings counted, overlaps
computed as set intersections. No vendor benchmarks were trusted at face value.

## 1. codeguard — rule-based scan

- **Dimensions used:** ERR, PERM, DIAG, RES_M (the skill's "all projects" set; DB
  skipped — no database).
- **Result:** Critical 0, High 0, Medium 12, plus a handful of Lows.
  - PERM (security) and RES_M (resources): clean — no secrets, no SQL, no shell,
    seeded RNG passed in (good practice, noted as a positive).
  - The bulk was ERR008 (missing input validation, 9 sites) — but in a closed
    simulation with internally generated inputs, most of these are Low in practice.
- **Skill weakness found:** the 0–100 score formula needs `max_possible`, which is
  undefined. Treat the score as indicative; count findings by severity instead.

## 2. Overlap: codeguard vs code-review-and-quality

Both were run on the largest module (`agent.py`, 194 lines); findings compared as sets.

- **Intersection:** 1 (an all-cells-filled edge case)
- **Union:** 8 → **overlap ≈ 12%**
- **Verdict:** complementary, not duplicative.
- **Key differentiator:** codeguard has **no performance dimension**. The review alone
  caught a K² Python loop in the rollout estimator (`_rollout_ev`) — the single
  biggest real finding of the whole shootout.

Pipeline consequence: codeguard runs first as a fast rule gate; the 5-axis review
runs last as judgment. Overlapping findings are merged, not double-counted.

## 3. test-automation — the detection failure

- `pytest --collect-only` → **"no tests collected"** (no pytest.ini, no `tests/` dir).
- Per the skill's own flow this means "framework not detected" → stop.
- Direct run: `python test_core.py` → **ALL TESTS PASSED in 0.05s.**
- **Verdict:** the skill wasn't broken; its *layout requirement* was. Fixed with the
  target-override patch (see `patches/`): when files are named explicitly, skip
  detection and run them directly.
- **Honest value assessment:** detection/execution/parsing are mechanical — any
  capable agent does them natively. The skill's real value is the **Closed Loop
  discipline**: fail → diagnose → fix → re-run, max 3 rounds, then stop and report.
  That's a guardrail against infinite fix loops (read: token burn) that none of the
  other skills in the set provide.

## 4. ponytail — on already-lean code

A review pass over the same code found **5 concrete simplifications, ~11 lines
(~1%)** — e.g. a repeated 6-minus-cost index expression across 4 sites → one helper.

**Verdict:** on lean code the corrective value is small; the value is *preventive* —
it stops the next 500 lines of over-engineering before they're written. It also
explicitly never cuts validation, error handling, or security, so it doesn't fight
the quality stages downstream.

## 5. product-engineer — habits, not tools

- No git history on the target repo → the commit-message check wasn't measurable there.
- Spot check of its rule 5 ("no number without a count") against the project's
  experiment log: numbers consistently carried their scope parameters
  (e.g. `C1 [143,107,99] … 59.1%`) — informal pass; rerunnable commands only sometimes.
- **Caveat (from the author's own eval):** the skill adds ~60% more turns and ~45%
  more cost, because it verifies more. A real tradeoff against token thrift.

## Bottom line

```
ponytail → write (thin slices) → codeguard → test-automation → code-review → product-engineer habits
```

Prevention first, fast mechanical checks second, expensive judgment last, honest
reporting throughout. Nothing here is asserted without a count — per the pipeline's
own rule 5.
